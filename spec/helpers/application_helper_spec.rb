require 'rails_helper'
require 'spec_helper'

RSpec.describe ApplicationHelper do
  describe 'methods' do
    xit 'can return whether a link path is active' do
      visit '/items'

      is_active?(items_path)
    end

    it 'can return the class for a flash message' do
      expect(flash_class('success')).to eq('alert alert-success')
      expect(flash_class('notice')).to eq('alert alert-info')
      expect(flash_class('error')).to eq('alert alert-warning')
      expect(flash_class('danger')).to eq('alert alert-danger')
    end
  end
end
