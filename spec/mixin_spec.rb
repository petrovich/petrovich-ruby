# encoding: utf-8
require 'spec_helper'

describe "Mix-in Petrovich extension into class" do
  before(:each) do
    @klass = Class.new do
      include Petrovich::Extension

      petrovich :firstname  => :my_firstname,
                :middlename => :my_middlename,
                :lastname   => :my_lastname

      def my_firstname
        'Пётр'
      end

      def my_middlename
        'Петрович'
      end
    
      def my_lastname
        'Петренко'
      end
    end
  end

  it { @klass.should respond_to :petrovich }

  describe 'class instance' do
    subject { @klass.new }

    it {
      should respond_to :my_firstname_dative
    }
  end  
end