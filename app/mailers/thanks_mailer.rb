class ThanksMailer < ApplicationMailer

	def thanks_email(user)
		@user = user
		mail(
			subject: "会員登録が完了しました",
			to: @user.email
			)
	end
end
