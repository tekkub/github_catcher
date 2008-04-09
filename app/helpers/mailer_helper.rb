module MailerHelper
	NAME_REMAPS = {
		"Tekkub Stoutwrithe" => "Tekkub",
	}

	def author_name(author)
		author = NAME_REMAPS[author["name"]] rescue author["name"]
	end
end
