# ParseCrowdXML
#  Used for parsing the crowd.cfg.xml file after it is created by atlassian
module ParseBambooXml
  class << self
    # Yes, it is odd to load the require this way, but along with doing it this way
    #   and the scripts in jmh-crowd::default, it allows it to sucessfully load this gem
    #   for a library
    def load_dependencies
      require 'nokogiri'
    end

    # Parses the properties field in crowd config files.
    def parse_config_property(xml_property, crowd_cfg_file)
      ParseBambooXml.load_dependencies
      parsed_file = File.open(crowd_cfg_file) { |f| Nokogiri::XML(f) }

      parsed_file.xpath('//property').each do |prop|
        Chef::Log.debug("#{prop.attributes['name']} is a property name in the crowd config file! #{xml_property}")
        next unless prop.attributes['name'].to_s == xml_property
        Chef::Log.debug(prop.children.to_s)
        return prop.children.to_s
      end
    end

    def parse_config(xml_property, crowd_cfg_file)
      ParseBambooXml.load_dependencies
      parsed_file = File.open(crowd_cfg_file) { |f| Nokogiri::XML(f) }
      property = parsed_file.xpath("//#{xml_property}")
      property[0].children.to_s
    end
  end
end
