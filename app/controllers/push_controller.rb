class PushController < ApplicationController
	REPO_MIRRORS = {
		"git://github.com/tekkub/tektest.git" => "git@github.com:tekkub/tektest_mirror.git",
		"git://github.com/tekkub/tourguide.git" => "ssh://git@git.kergoth.com/srv/git/git.tekkub.net/TourGuide.git/",
	}

	def index
		@payload = ActiveSupport::JSON.decode(params[:payload]) rescue nil

		unless @payload.blank?
			github_repo = @payload["repository"]["url"].sub("http", "git") + ".git"
			branch = @payload["ref"].sub("refs/heads/", "")
			@payload["commits"].each_pair do |sha1,commit|
				CommitMailer.deliver_commit_notification("githubcatcher@tekkub.net", @payload["repository"]["name"], sha1, commit, branch)
				CommitMailer.deliver_cia(@payload["repository"]["name"], sha1, commit, branch)
			end

			clone(github_repo, REPO_MIRRORS[github_repo], branch) if REPO_MIRRORS[github_repo]
		end

		render :text => "Nothing to see here!"
	end

	private

	def clone(source_repo, dest_repo, branch)
		local_repo = "github_mirror_#{source_repo.hash}"
		local_path = "/home/tekkub/temp/#{local_repo}"

		if !File.exist?(local_path)
			puts "\n---Cloning #{source_repo}\n"
			#~ system "echo 'Cloning from github:#{github_repo} to local:#{repo}' >> /home/tekkub/temp/githubcatcher.log"
			#~ system "cd /home/tekkub/temp && git clone --bare #{source_repo} #{local_repo}"
			system "cd /home/tekkub/temp && git clone #{source_repo} #{local_repo}"
			puts "\n---Add remote\n"
			#~ system "cd #{local_path} && git remote add github #{dest_repo}"
			system "cd #{local_path} && git remote add mirror #{dest_repo}"
		end

		branches = IO.popen("cd #{local_path} && git branch -r").readlines
		branches << "origin/#{branch}"
		branches = branches.uniq.map {|l| l.strip.split("/")}.reject! {|l| l[0] == "mirror" || l[1] == "HEAD"}.map {|l| "+#{l[1]}:#{l[1]}"}
		p "git pull origin " + branches.join(" ")

		puts "\n---Pull #{source_repo} #{branch}\n"
		system "cd #{local_path} && git pull origin #{branches.join(" ")}"
		#~ system "cd #{local_path} && git pull origin"
		#~ system "cd #{local_path} && git pull mirror"
		#~ system "cd #{local_path} && git branch -f temp remotes/github/#{branch}"
		#~ system "echo 'Mirroring from github:#{github_repo} to #{repo}' >> /home/tekkub/temp/githubcatcher.log"
		puts "\n---Push #{dest_repo} #{branch}\n"
		#~ system "cd #{local_path} && git push --tags --force mirror temp:#{branch}"
		system "cd #{local_path} && git push --mirror mirror"

		puts "\n---Finished #{source_repo} --> #{dest_repo}\n"
	end

end

=begin
Payload example:
{
	"repository"=>{
		"name"=>"tektest",
		"url"=>"http://github.com/tekkub/tektest",
		"owner"=>{"name"=>"tekkub", "email"=>"tekkub@gmail.com"}
	},
	"commits"=>{
		"1f567e02299e134e8aeaa46592a8615f1d43db2a"=>{
			"timestamp"=>Tue Apr 08 15:06:24 -0600 2008,
			"message"=>"Test",
			"author"=>{"name"=>"Tekkub", "email"=>"tekkub@gmail.com"},
			"url"=>"http://github.com/tekkub/tektest/commit/1f567e02299e134e8aeaa46592a8615f1d43db2a"
		},
		"f4a67241eab1fa352730b6ba43a238ae2d825b7a"=>{
			"timestamp"=>Tue Apr 08 15:06:21 -0600 2008,
			"message"=>"Test",
			"author"=>{"name"=>"Tekkub", "email"=>"tekkub@gmail.com"},
			"url"=>"http://github.com/tekkub/tektest/commit/f4a67241eab1fa352730b6ba43a238ae2d825b7a"
		},
		"04b7f7fac510672594641bb55aaf18c7f66b4b01"=>{
			"timestamp"=>Tue Apr 08 15:06:21 -0600 2008,
			"message"=>"Test",
			"author"=>{"name"=>"Tekkub", "email"=>"tekkub@gmail.com"},
			"url"=>"http://github.com/tekkub/tektest/commit/04b7f7fac510672594641bb55aaf18c7f66b4b01"
		},
		"d1be007ef78b48b3559247bdbc84470c9ecbde77"=>{
			"timestamp"=>Tue Apr 08 15:06:20 -0600 2008,
			"message"=>"Test",
			"author"=>{"name"=>"Tekkub", "email"=>"tekkub@gmail.com"},
			"url"=>"http://github.com/tekkub/tektest/commit/d1be007ef78b48b3559247bdbc84470c9ecbde77"
		},
		"101663478af06878a835e879040fce3ed9bf1a5a"=>{
			"timestamp"=>Tue Apr 08 15:06:23 -0600 2008,
			"message"=>"Test",
			"author"=>{"name"=>"Tekkub", "email"=>"tekkub@gmail.com"},
			"url"=>"http://github.com/tekkub/tektest/commit/101663478af06878a835e879040fce3ed9bf1a5a"
		},
		"5eb5d2d1faef0180d39a458c970375cec9e73ac9"=>{
			"timestamp"=>Tue Apr 08 15:06:22 -0600 2008,
			"message"=>"Test",
			"author"=>{"name"=>"Tekkub", "email"=>"tekkub@gmail.com"},
			"url"=>"http://github.com/tekkub/tektest/commit/5eb5d2d1faef0180d39a458c970375cec9e73ac9"
		}
	},
	"after"=>"1f567e02299e134e8aeaa46592a8615f1d43db2a",
	"ref"=>"refs/heads/master",
	"before"=>"c35450091cd299703f63933933ab064440d513d9"
}

before = remote HEAD before push
after  = remote HEAD after push

=end

