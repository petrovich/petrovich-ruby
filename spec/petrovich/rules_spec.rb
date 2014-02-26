# encoding: utf-8

require 'spec_helper'

describe Petrovich::Rules do
  subject { Petrovich::Rules.new(:male) }

  it 'should raise an error when it is impossible to find a rule' do
    rule = Petrovich::RULES['lastname']
    assert_raises(Petrovich::UnknownRuleException){ subject.send(:find_for, 'Хэмингуэй', :nominative, :genitive, rule) }
  end

  it 'should leave an unknown word as is' do
    rule = Petrovich::RULES['lastname']
    assert_equal 'Хэмингуэй', subject.send(:find_and_apply, 'Хэмингуэй', :dative, :nominative, rule)
  end
end
