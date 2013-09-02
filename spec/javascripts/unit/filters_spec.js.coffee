describe 'filters', ->
  beforeEach module('ocarinaFilters')

  describe 'truncate', ->
    truncate = null
    beforeEach inject ($filter) ->
      truncate = $filter('truncate')

    # TODO
    it "should do nothing if char count is not provided", ->
      expect(truncate("1234567890")).toEqual "1234567890"

    it "should not trim string if less than char count", ->
      expect(truncate("1234567890", 30)).toEqual "1234567890"

    it "should trim string if greate than char count", ->
      expect(truncate("1234567890", 5)).toEqual "12345..."

    it "should trim string including the space", ->
      expect(truncate("123456789 10 11 12 13 14", 14)).toEqual "123456789 10..."

    it "should trim string breaking on word if flag true", ->
      expect(truncate("123456789 10 11 12 13 14", 14, true)).toEqual "123456789 10 1..."

    it "should handle invalid numbers", ->
      expect(truncate("1234567890", 0)).toEqual ""

    it "should handle invalid chars numbers type", ->
      expect(truncate("1234567890", "abc")).toEqual "1234567890"
