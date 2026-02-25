# frozen_string_literal: true

require "sinatra/base"
require "json"
require "fileutils"
require "shellwords"

class PumaDevManager < Sinatra::Base
  enable :sessions
  set :views, File.join(__dir__, "views")

  PUMA_DEV_DIR = File.expand_path("~/.puma-dev")

  helpers do
    def puma_dev_dir
      PUMA_DEV_DIR
    end

    def list_apps
      return [] unless File.directory?(puma_dev_dir)

      Dir.entries(puma_dev_dir)
        .reject { |f| f.start_with?(".") }
        .sort
        .map { |name| build_app_info(name) }
    end

    def build_app_info(name)
      path = File.join(puma_dev_dir, name)
      symlink = File.symlink?(path)
      target = symlink ? File.readlink(path) : path
      resolved = File.expand_path(target, puma_dev_dir)
      branch = git_branch(resolved)

      {
        name: name,
        url: "#{name}.test",
        symlink: symlink,
        target: resolved,
        branch: branch
      }
    end

    def git_branch(path)
      return nil unless File.directory?(path)
      result = `git -C #{shellescape(path)} branch --show-current 2>/dev/null`.strip
      result.empty? ? nil : result
    end

    def git_worktrees(path)
      return [] unless File.directory?(path)

      output = `git -C #{shellescape(path)} worktree list --porcelain 2>/dev/null`
      return [] if output.nil? || output.strip.empty?

      worktrees = []
      current = {}

      output.each_line do |line|
        line = line.chomp
        if line.empty?
          worktrees << current unless current.empty?
          current = {}
        elsif line.start_with?("worktree ")
          current[:path] = line.sub("worktree ", "")
        elsif line.start_with?("HEAD ")
          current[:head] = line.sub("HEAD ", "")
        elsif line.start_with?("branch ")
          ref = line.sub("branch ", "")
          current[:branch] = ref.sub(%r{^refs/heads/}, "")
        elsif line == "detached"
          current[:branch] = "(detached)"
        elsif line == "bare"
          current[:bare] = true
        end
      end
      worktrees << current unless current.empty?

      # Filter out bare worktrees
      worktrees.reject { |wt| wt[:bare] }
    end

    def shellescape(str)
      Shellwords.escape(str)
    end

    def flash_message
      session.delete(:flash)
    end

    def h(text)
      Rack::Utils.escape_html(text.to_s)
    end
  end

  get "/" do
    @apps = list_apps
    erb :index
  end

  get "/apps/:name" do
    name = params[:name]
    path = File.join(puma_dev_dir, name)

    unless File.exist?(path) || File.symlink?(path)
      halt 404, "App not found"
    end

    @app = build_app_info(name)
    @worktrees = git_worktrees(@app[:target])

    # Mark the active worktree (the one matching the current symlink target)
    @worktrees.each do |wt|
      wt[:active] = (File.expand_path(wt[:path]) == File.expand_path(@app[:target]))
    end

    @flash = flash_message
    erb :app
  end

  post "/apps/:name/switch" do
    name = params[:name]
    worktree_path = params[:worktree_path].to_s.strip
    link_path = File.join(puma_dev_dir, name)

    # Validate the app exists and is a symlink
    unless File.symlink?(link_path)
      session[:flash] = { type: "error", message: "#{name} is not a symlink — cannot switch." }
      redirect "/apps/#{name}"
      return
    end

    # Validate worktree_path is an absolute path
    unless worktree_path.start_with?("/")
      session[:flash] = { type: "error", message: "Invalid path: must be absolute." }
      redirect "/apps/#{name}"
      return
    end

    # Validate the path exists on disk
    unless File.directory?(worktree_path)
      session[:flash] = { type: "error", message: "Directory does not exist: #{worktree_path}" }
      redirect "/apps/#{name}"
      return
    end

    # Validate it's a git worktree (has .git file or directory)
    git_path = File.join(worktree_path, ".git")
    unless File.exist?(git_path)
      session[:flash] = { type: "error", message: "Not a git worktree: #{worktree_path}" }
      redirect "/apps/#{name}"
      return
    end

    # Remove existing symlink and create new one
    File.delete(link_path)
    File.symlink(worktree_path, link_path)

    # Touch tmp/restart.txt to trigger puma-dev reload
    tmp_dir = File.join(worktree_path, "tmp")
    if File.directory?(tmp_dir)
      restart_file = File.join(tmp_dir, "restart.txt")
      FileUtils.touch(restart_file)
    end

    branch = git_branch(worktree_path)
    branch_label = branch ? "  [#{branch}]" : ""
    session[:flash] = {
      type: "success",
      message: "Switched! #{name}.test → #{worktree_path}#{branch_label}"
    }

    redirect "/apps/#{name}"
  end
end
