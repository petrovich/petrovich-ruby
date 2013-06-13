# encoding: utf-8

require_relative '../spec_helper'

describe Petrovich::Rules do
  subject { Petrovich::Rules.new(:male) }

  it 'should raise an error when it is impossible to find a rule' do
    rule = Petrovich::RULES['lastname']
    expect { subject.send(:find_for, 'Хэмингуэй', rule) }.
      to raise_error(Petrovich::UnknownRuleException)
  end

  it 'should left the unknown word as is' do
    rule = Petrovich::RULES['lastname']
    subject.send(:find_and_apply, 'Хэмингуэй', :dative, rule).
      should == 'Хэмингуэй'
  end
end
