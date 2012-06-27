module AccountHelper
  def make_account
    visit '/signup'
    fill_in 'Username', :with => 'username'
    fill_in 'Password', :with => 'password'
    fill_in 'Password confirmation', :with => 'password'
    click_on 'Sign up'
  end
  
  def login
    login_with('username', 'password')
  end
  
  def login_with(username, password)
    fill_in 'Username', :with => username
    fill_in 'Password', :with => password
    click_button 'Log In'
  end
  
end