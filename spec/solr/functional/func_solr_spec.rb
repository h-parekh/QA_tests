# frozen_string_literal: true

require 'solr/solr_spec_helper'
# Using the SOLR Ping API to check status of SOLR
# https://lucene.apache.org/solr/guide/6_6/ping.html#api-examples
feature 'Ping SOLR status', js: true do
  scenario 'For "curate" core', :smoke_test, :read_only do
    visit '/solr/curate/admin/ping?wt=ruby'
    expect(eval(page.text).fetch('status')).to eq('OK')
  end

  scenario 'For "inquisition" core', :smoke_test, :read_only do
    visit '/solr/inquisition/admin/ping?wt=ruby'
    expect(eval(page.text).fetch('status')).to eq('OK')
  end

  scenario 'For "medieval_micro" core', :smoke_test, :read_only do
    visit '/solr/medieval_micro/admin/ping?wt=ruby'
    expect(eval(page.text).fetch('status')).to eq('OK')
  end
end
