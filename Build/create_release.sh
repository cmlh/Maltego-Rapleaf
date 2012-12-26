#!/bin/sh
#
# Creates the download release
#
# christian.heinrich@cmlh.id.au
#
cd ..
tar -cvf ./Releases/Maltego-Rapleaf-$1.tar ./Local_Transforms/etc/*.conf ./Local_Transforms/Perl-Maltego/*.pl ./Local_Transforms/Personalization_API/*.pl ./Local_Transforms/Utilities_API/*.pl
tar -rvf ./Releases/Maltego-Rapleaf-$1.tar ./Entities/*.mtz
gzip ./Releases/Maltego-Rapleaf-$1.tar
cd Build
