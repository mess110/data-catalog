Factory.define :data_source do |ds|
  ds.uid 'fema-public-assistance-funded-projects-detail'
  ds.title 'FEMA Public Assistance Funded Projects Detail'
  ds.url 'http://www.data.gov/raw/2539'
  ds.description 'Through the PA Program (CDFA Number 97.036), FEMA provides supplemental Federal disaster grant assistance for debris removal, emergency protective measures, and the repair, replacement, or restoration of disaster-damaged, publicly owned facilities and the facilities of certain Private Non-Profit (PNP) organizations. The PA Program also encourages protection of these damaged facilities from future events by providing assistance for hazard mitigation measures during the recovery process. This dataset lists all public assistance recipients, designated as Applicants in the data. The dataset also features a list of every funded, individual project, called project worksheets.'
  ds.documentation_url 'http://www.fema.gov/datasets/data.gov.FEMAPublicAssistanceFundedProjectsDetail.metadata.xls'
  ds.license 'public domain'
  ds.license_url 'http://www.data.gov/datapolicy'
  ds.released({ 'year' => 2010, 'month' => 7, 'day' => 15 })
  ds.updated({ 'year' => 2010, 'month' => 11, 'day' => 18 })
  ds.period_start({ 'year' => 1998 })
  ds.period_end({ 'year' => 2010 })
  ds.frequency 'quarterly'
  ds.missing false
  ds.facets({})
  ds.granularity 'Full Address for most records, otherwise County'
  ds.geographic_coverage 'United States and Applicable Territories'
  ds.interestingness 3
  ds.documentation_quality 4
  ds.data_quality 5
end