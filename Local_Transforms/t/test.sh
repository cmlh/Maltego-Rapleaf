#!/bin/sh
#
# This is a workaround until I convert this to TAP
#
# christian.heinrich@cmlh.id.au
# 
../Utilities_API/from_affiliation_facebook-to_rapleaf_gender.pl "Christian Heinrich" "person.name=Christian Heinrich#network=Facebook#uid=100002552265389#profile_url=http://www.facebook.com/cmlh.id.au"

# Test of sub trim() of perl-maltego.pl
../Utilities_API/from_affiliation_facebook-to_rapleaf_gender.pl "  Christian Heinrich  " "person.name=  Christian Heinrich  #network=Facebook#uid=100002552265389#profile_url=http://www.facebook.com/cmlh.id.au"
../Utilities_API/from_email-to_rapleaf_name.pl "Christian Heinrich" "christian.heinrich@cmlh.id.au"
../Personalization_API/from_md5-to_rapleaf.pl "1f17d502d2f7a07878933831529b780d"
../Personalization_API/from_sha1-to_rapleaf.pl "22f291a9ae8088af18c2b75e8f96b3dceec8de64"
