
class PushController < ApplicationController
	def index
		puts "\nIncoming push"
		@payload = ActiveSupport::JSON.decode(params[:payload]) rescue nil

		if @payload.blank?

		else
			p @payload

			github_repo = @payload.repository.url.sub("http", "git") + ".git"
			p github_repo

			branch = @payload.ref.sub("refs/heads/", "")
			p branch
		end

		render :text => "Nothing to see here!"
	end

	private

	def clone(source_repo, dest_repo, branch)
		if repo = params[:id]
			local_path = "/home/tekkub/temp/github_#{repo}"
			if !File.exist?(local_path)
				puts "\n---Cloning #{repo}\n"
				#~ system "echo 'Cloning from github:#{github_repo} to local:#{repo}' >> /home/tekkub/temp/githubcatcher.log"
				#~ system "cd /home/tekkub/temp && git clone git://github.com/tekkub/#{github_repo}.git github_#{repo}"
				#~ puts "\n---Add remote\n"
				#~ system "cd /home/tekkub/temp/github_#{repo} && git remote add mirror ssh://git@git.kergoth.com/srv/git/git.tekkub.net/#{repo}.git/"
			end
			#~ puts "\n---Pull #{repo}\n"
			#~ system "cd /home/tekkub/temp/github_#{repo} && git pull"
			#~ system "cd /home/tekkub/temp/github_#{repo} && git pull mirror"
			#~ system "echo 'Mirroring from github:#{github_repo} to #{repo}' >> /home/tekkub/temp/githubcatcher.log"
			#~ puts "\n---Push #{repo}\n"
			#~ system "cd /home/tekkub/temp/github_#{repo} && git push --force --all mirror"

			puts "\n---Finished #{github_repo} --> #{repo}\n"
			render :text => "Pushed github repo '#{github_repo}' to mirror repo '#{repo}'"
		else
			render :text => "Nothing to see here!"
		end
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

