class Search < ActiveRecord::Base
  def missings
    @missings ||= find_missings
  end

  def last_seen_string
    self.last_seen.strftime("%d.%m.%Y") if self.last_seen
    self.last_seen_start.strftime("%d.%m.%Y") + ' - ' + self.last_seen_end.strftime("%d.%m.%Y") if self.last_seen.nil? && self.last_seen_start && self.last_seen_end
  end
   
  def last_seen=(value)
    logger.debug(value)
    dates = value.split(" - ")
    dates.each_with_index { |date,index| dates[index] = Date.parse(date) }
    self.last_seen_start, self.last_seen_end = dates if dates.size == 2
    self.last_seen = dates.first if dates.size == 1
  end

  private

  def find_missings
    logger.debug("#{conditions.inspect} #{geo}")
    if geo.nil?
      Missing.search keywords, :with => conditions
    else
      geo_conditions = { "@geodist" => 0.0..20_000.0 }
      Missing.search keywords, :with => geo_conditions.merge!(conditions), :geo => geo 
    end

  end

  def geo
    if region
      geo_result = Geocoder.search(region).first

      [(geo_result.latitude / 180) * Math::PI, (geo_result.longitude / 180) * Math::PI] unless geo_result.nil?
    end
  end

  def age_conditions
    minimum_age = self.minimum_age || 0
    maximum_age = self.maximum_age || 150

    { :age => minimum_age..maximum_age } unless minimum_age.blank? && maximum_age.nil? 
  end

  def gender_conditions
    { :gender => male } unless male.nil?
  end

  def last_seen_conditions
  end
  
  def conditions 
    conditions = {}
    logger.debug(conditions_parts)
    conditions_parts.each { |part| conditions.merge!(part) }
    
    conditions
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
end

