class CommitMailer < ActionMailer::Base

  def commit_notification(recipient, repo_name, commit_sha1, commit, branch)
    subject "[#{repo_name} commit] " + commit["message"].split("\n").first
    recipients recipient
    from 'github-commits@tekkub.net'
    #~ content_type "text/html"
    body :commit => commit, :branch => branch
  end

  def cia(repo_name, commit_sha1, commit, branch)
    subject 'DeliverXML'
    recipients 'cia@cia.vc'
    from 'github-commits@tekkub.net'
    content_type "text/xml"
    body :commit => commit, :branch => branch, :source => repo_name, :sha1 => commit_sha1
  end

end
