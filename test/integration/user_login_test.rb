require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  def setup
    # create a object by 'fixtures/users.yml' and using key :record
    # users is the fixtures's name
    # :record is the key of any record in the fixtures
    @user = users(:record)
  end

  # test "login with valid information" do
  #   # visit the login page
  #   get new_user_session_path
  #   # make a login request to session controller
  #   post user_session_path, user: { email: 'islam0324@gmail.com',
  # password: '112233' }
  #   # # page is redirected t 'users/show' page
  #   assert_redirected_to root_path
  #   # # actully visit the redirected page
  #   follow_redirect!
  #   # # template is completely loaded
  #   assert_template root_path
  #   # # no 'log in' link on that page
  #   assert_select "a[href=?]", login_path, count:0
  #   # # 'log out' link on the page
  #   assert_select "a[href=?]", logout_path
  #   # # 'profile' or link to 'users/show' page
  #   assert_select "a[href=?]", user_path(@user)
  # end

  # test "login with invalid information" do
  #   # visit the login page
  #   get new_user_session_path
  #   # make a login request to session controller
  #   post user_session_path, User.new(email: 'islam032@gmail.com',
  # password: '112233' )
  #   # page is redirected t 'users/show' page
  #   assert_redirected_to root_path
  #   # actully visit the redirected page
  #   follow_redirect!
  #   # template is completely loaded
  #   assert_template root_path
  #   # no 'log in' link on that page
  #   assert_select "a[href=?]", login_path, count:1
  # end

  # test "logout from application" do
  #   delete user_session_path
  #   # user is no more logged_in
  #   assert_not user_signed_in?
  #   # redirected to root path?
  #   assert_redirected_to root_path
  #   # follow the redirected path actually
  #   follow_redirect!
  #   # link for login
  #   assert_select  "a[href=?]", login_path
  #   # no link for logout
  #   assert_select "a[href=?]", logout_path, count:0
  #   # no link for profile or show
  #   assert_select "a[href=?]", user_path(@user), count:0
  # end
end
