require 'spec_helper'

describe SharedHelper do
  before do
    @index_url = "http://libstaff.neu.edu/snell_mail/users"
   
    @new_url = "http://libstaff.neu.edu/snell_mail/users/new"
    
    @error = true
  end
  
  it 'index_url? takes arguments' do
    Proc.new { index_url? }.must_raise ArgumentError
  end

  it 'index_url? returns true if pluralized class is in url and no error' do
    it = index_url?(@index_url, @nil_error)
    it.must_equal true
  end

  it 'index_url? returns false if error is present' do
    it = index_url?(@index_url, @error)
    it.must_equal false
  end
  
  it 'index_url? returns false if url does not end in s or contain s?' do
    it = index_url?(@new_url, @nil_error)
    it.wont_equal true
  end

  it 'new_url? takes arguments' do
    Proc.new { new_url? }.must_raise ArgumentError
  end

  it 'new_url? wont return false if new is in the url' do
    it = new_url?(@new_url, @nil_error)
    it.wont_equal false
  end

  it 'new_url? wont return true if there is no error and no new in the url' do
    it = new_url?(@index_url, @nil_error)
    it.wont_equal true
  end

  it 'new_url? returns true if there is an error' do
    it = new_url?(@index_url, @error)
    it.must_equal true
  end
end