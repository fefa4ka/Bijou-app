# config/initializers/geocoder.rb

# geocoding service (see below for supported options):
Geocoder::Configuration.lookup = :yandex

# to use an API key:
Geocoder::Configuration.api_key = "AMIjr04BAAAAiqLwEAIAxJ3Rc1d-Pqr4lDahYvOYW2vbYVEAAAAAAAAAAADDG5GEvPqd72eJsxxDy4dds6D8OA=="

# geocoding service request timeout, in seconds (default 3):
Geocoder::Configuration.timeout = 5


# language to use (for search queries and reverse geocoding):
Geocoder::Configuration.language = :ru
