class Search < ActiveRecord::Base
  attr_accessor :ages

  def missings
    @missings ||= find_missings
  end

  def ages
    self[:ages]
    form.validate().cancelSubmit = true;        
  end

  def ages=(value)
    case value
    when "children"
      self.minimum_age = 1
      self.maximum_age = 18
    when "adult" 
      self.minimum_age = 19
      self.maximum_age = 50
    when "eldery"
      self.minimum_age = 51
      self.maximum_age = 150
    end
    
    self[:ages] = value
  end

  def last_seen=(value)
    case value
    when "week"
      self.last_seen_start = 1.week.ago
    when "month"
      self.last_seen_start = 1.month.ago
    when "year"
      self.last_seen_start = 1.year.ago
    end

    self.last_seen_end = Time.now
    
    self[:last_seen] = value
  end
  
  def male=(value)
    self[:male] = value unless value == "any"
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
    { :last_seen => self.last_seen_start..self.last_seen_end } if self.last_seen_start && self.last_seen_end
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

