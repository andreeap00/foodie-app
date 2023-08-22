require 'rails_helper'
include SessionsHelper

RSpec.describe SessionsHelper, type: :helper do
  let!(:user) { User.create(name: 'Itachi Uchiha', email: 'itachi.uchiha@yahoo.com', password: 'Password1!', role: :admin) }

  describe '#log_in' do
    it 'logs in user' do
      log_in(user)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe '#remember' do
    it 'remembers user' do
      remember(user)
      expect(cookies.encrypted[:user_id]).to eq(user.id)
      expect(cookies.permanent[:remember_token]).to eq(user.remember_token)
    end
  end

  describe '#current_user' do
    it 'returns current user based on session' do
      session[:user_id] = user.id
      expect(current_user).to eq(user)
    end

    it 'returns current user based on cookies' do
      user.remember
      cookies.encrypted[:user_id] = user.id
      cookies[:remember_token] = user.remember_token
      expect(current_user).to eq(user)
    end

    it 'returns nil when users logged out' do
      expect(current_user).to be_nil
    end
  end

  describe '#current_user?' do
    it 'returns true for authenticated user' do
      session[:user_id] = user.id
      expect(current_user?(user)).to be true
    end

    it 'returns false when user logged out' do
      expect(current_user?(user)).to be false
    end
  end

  describe '#logged_in?' do
    it 'returns true when user is logged in' do
      session[:user_id] = user.id
      expect(logged_in?).to be true
    end

    it 'returns false when no user is logged in' do
      expect(logged_in?).to be false
    end
  end

  describe '#authenticate' do
    before do
      allow(helper).to receive(:logged_in?).and_return(false)
    end

    it 'does not redirect when logged in' do
      session[:user_id] = user.id
      expect(response).not_to eq(:redirect_to)
    end
  end
end