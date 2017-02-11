module UserLogging
  def sign_in
    user = FactoryGirl.create(:user)
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end
end

RSpec.configure do |config|
  config.include UserLogging, type: :controller
end
