# encoding: utf-8

require 'spec_helper'

describe "Mix-in Petrovich extension into class" do
  before do
    @klass = Class.new do
      include Petrovich::Extension

      petrovich :firstname  => :my_firstname,
                :middlename => :my_middlename,
                :lastname   => :my_lastname,
                :gender     => :my_gender

      def my_firstname
        'Пётр'
      end

      def my_middlename
        'Петрович'
      end
    
      def my_lastname
        'Петренко'
      end

      def my_gender
        :male
      end
    end
  end

  it { assert_respond_to @klass, :petrovich }

  describe 'class instance' do
    subject { @klass.new }

    it 'should respond to generated methods' do
      assert_respond_to subject, :my_firstname_dative
      assert_respond_to subject, :my_middlename_dative
      assert_respond_to subject, :my_lastname_dative
    end
  end  
end
