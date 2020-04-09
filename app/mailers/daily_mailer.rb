class DailyMailer < ApplicationMailer
	def daily_email
		@users = User.all
		@users.each do |user|
			@user = user
			mail(
				subject: "今日のお知らせ",
				to: user.email
				)
		end
	end
end
