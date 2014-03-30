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

  describe 'class configuration' do
    class Person
      include Petrovich::Extension
    end
    class Pet
      include Petrovich::Extension
      petrovich :firstname => :alias
    end
    class Parent < Person
      petrovich :firstname => :nickname
    end
    class Child < Parent
      petrovich :lastname => :name
    end

    it 'should have configuration' do
      assert_respond_to Person, :petrovich_configuration
    end

    it 'should be configured properly' do
      assert_equal :alias, Pet.petrovich_configuration[:firstname]
      assert_equal nil, Pet.petrovich_configuration[:lastname]
    end

    it 'should be properly subclassable and extended by Petrovich::Extension' do
      assert_respond_to Parent, :petrovich_configuration

      assert_equal :nickname, Parent.petrovich_configuration[:firstname]
      assert_equal nil, Parent.petrovich_configuration[:lastname]
    end

    it 'should retain the configuration of parent class and be able overwrite it' do
      assert_equal :nickname, Child.petrovich_configuration[:firstname]
      assert_equal :name, Child.petrovich_configuration[:lastname]
    end
  end
end
