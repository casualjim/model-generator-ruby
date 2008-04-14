require File.dirname(__FILE__) + "/light_speed_property_base"
class LightSpeedProperty < LightSpeedPropertyBase
  def initialize(params = {})
    super
  end
  
  def should_generate_field?(user_file_content)
    Regexp.compile("#{clr_type!}\\??\s+_#{name.camelcase(:lower)}", Regexp::MULTILINE).match(user_file_content).nil?
  end
  
  def should_generate_property?(user_file_content)
    Regexp.compile("#{clr_type!}\\??\s+_#{name}", Regexp::MULTILINE).match(user_file_content).nil?
  end
  
  def to_field(tabindex = 0)
    tabs = ""
    result = ""
    0.upto(tabindex-1) { tabs << "\t" }
    
    result << validate_presence_attribute(tabs) if should_validate_presence?
    result << "#{tabs}[ValidateUnique]\n" if unique?
    result << "#{tabs}private #{clr_type} _#{name.camelcase(:lower)};\n"
  end
  
  def to_property(tabindex = 0)
    tabs = ""
    result = ""
    0.upto(tabindex-1) { tabs << "\t" }
    
    result << "#{tabs}public virtual #{clr_type} #{name}\n"
    result << "#{tabs}{\n#{tabs}\tget { return _#{name.camelcase(:lower)}; }\n"
    result << "#{tabs}\tset { Set(ref _#{name.camelcase(:lower)}, value); }\n#{tabs}}\n"
  end
  
  def clr_type
    clrtype = DB::DbiSqlServer.to_clr_type sql_type
    (clrtype != "string" && nullable? ? "#{clrtype}?" : clrtype)
  end
  
  def clr_type!
    DB::DbiSqlServer.to_clr_type sql_type
  end
  
  private
    
    def validate_presence_attribute(tabs)
        foreign_key? ? "#{tabs}[Dependent(ValidatePresence = true)]" : "#{tabs}[ValidatePresence]\n"
    end
    
    def is_reserved_property_name?
      %w(LockVersion CreatedOn DeletedOn UpdatedOn).any? {|reserved| reserved == name }     
    end
    
    def is_non_nullable_type?
      %w(short byte long int double bool decimal float).any?{ |t| t == clr_type}
    end
    
    def should_validate_presence?
      result =  !!!( (!foreign_key? && is_non_nullable_type?) ||  nullable?    || is_reserved_property_name?)
      result
    end
  
end
