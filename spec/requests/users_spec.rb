require 'spec_helper'

describe 'users API' do

  before :each do
    @user = FactoryGirl.create :user, email: 'testo@testonex.com', user_token: 'NFAxNDU2N3l1aVVVV'
    @env ||= {}
    @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('4P14567yuiUUU','s4cr4t4567yuiXX')
  end

  it 'creates or retrieves a user_token by email on create_token action' do
    user = FactoryGirl.create :user
    get "/v1/users/createtoken/?email=#{user.email}", {}, @env

    expect(response).to be_success
    expect(json['data']['UID'].length > 12).to eq true
  end

  it 'creates a new user on create_user action' do
    params = {
      user_type: 'individual',
      first: 'John',
      last: 'Smith',
      email: 'jsonmith66@jmithmx.com',
      country: 'US',
      new_password: 'ASQWert78@@',
      new_password_confirmation: 'ASQWert78@@'
    }

    post '/v1/users/create', params, @env

    # test for the 200 status-code
    expect(response).to be_success
    expect(json['data']['email']).to eq 'jsonmith66@jmithmx.com'
    expect(json['data']['UID'].length > 12).to eq true
  end

  it 'updates a user on update_user action' do
    params = {
      user_token: @user.user_token,
      first: 'John',
      last: 'Smith',
      email: 'jsonmith66@updated.com'
    }

    post '/v1/users/update', params, @env

    # test for the 200 status-code
    expect(response).to be_success
    expect(json['data']['email']).to eq 'jsonmith66@updated.com'
  end

  it 'retrieves a user by email on get_token action' do
    get '/v1/users/gettoken/?email=testo@testonex.com', {}, @env

    expect(response).to be_success
    expect(json['data']['email']).to eq @user.email
  end

  it 'retrieves a user by id on get_token action' do
    get '/v1/users/gettoken/?email=testo@testonex.com', {}, @env

    expect(response).to be_success
    expect(json['data']['id']).to eq @user.id.to_s
  end

  it 'sets a user as active false on delete action' do
     get "/v1/users/delete/#{@user.user_token}", {}, @env

    expect(response).to be_success
    expect(json['account']['message']).to eq 'User sucesfully deleted'
  end

end