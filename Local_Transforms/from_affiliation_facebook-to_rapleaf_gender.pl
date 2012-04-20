#!/usr/bin/env perl
#
# Forked from https://github.com/Rapleaf/Personalization-Dev-Kits/blob/master/perl/RapleafApi.pl

use LWP::UserAgent;
use JSON;
use URI::Escape;
use Config::Std;
# use Smart::Comments;

my $VERSION = "0.0.1"; # May be required to upload script to CPAN i.e. http://www.cpan.org/scripts/submitting.html

# CONFIGURATION
# REFACTOR with "easydialogs" e.g. http://www.paterva.com/forum//index.php/topic,134.0.html as recommended by Andrew from Paterva
read_config './etc/Personalization_API.conf' => my %config;
my $API_KEY = $config{'PersonalizationAPI'}{'API_Key'};

# "###" is for Smart::Comments CPAN Module
### \$API_KEY is: $API_KEY;

$ua = LWP::UserAgent->new;

# $ua->timeout(2);
$ua->agent("RapleafApi/Perl/1.1");

my $maltego_selected_entity_value = $ARGV[0];

my $maltego_additional_field_values = $ARGV[1];

# "###" is for Smart::Comments CPAN Module
### \$maltego_additional_field_values is: $maltego_additional_field_values;

my @maltego_additional_field_values =
  split( '#', $maltego_additional_field_values );

# TODO If UID field is empty, then extract UID from the "Profile URL" field
my $affilation_facebook_name = $maltego_additional_field_values[2];

# "###" is for Smart::Comments CPAN Module
### \$affilation_facebook_name is: $affilation_facebook_name;

$affilation_facebook_name =~ s/(person.name=)//g;

# Remove single quotes
$affilation_facebook_name =~ s/(\')//g;

# Remove whitespace
$affilation_facebook_name =~ s/^\s+|\s+$//g;

# "###" is for Smart::Comments CPAN Module
### \$affilation_facebook_name is: $affilation_facebook_name;

my @affilation_facebook_name = split( / /, $affilation_facebook_name );
$affilation_facebook_first_name = $affilation_facebook_name[0];

# "###" is for Smart::Comments CPAN Module
### \$affilation_facebook_first_name is: $affilation_facebook_first_name;

$affilation_facebook_first_name = uri_escape($affilation_facebook_first_name);

# "###" is for Smart::Comments CPAN Module
### \$maltego_selected_entity_value is: $maltego_selected_entity_value;

my $response = query_by_name($affilation_facebook_first_name);

# "###" is for "Smart::Comments CPAN Module
### \$response->{gender} is :$response->{gender}
### \$response->{likelihood} is :$response->{likelihood}

# http://ctas.paterva.com/view/Specification#Message_Wrapper
print("<MaltegoMessage>\n");
print("<MaltegoTransformResponseMessage>\n");
print("<UIMessages>\n");
print(
"		<UIMessage MessageType=\"Inform\">To Rapleaf Gender (Utilities API) - Local Transform v$VERSION</UIMessage>\n"
);

# http://ctas.paterva.com/view/Specification#Entity_definition

print("</UIMessages>\n");
print("\t<Entities>\n");
if ( $response->{gender} eq "Male" ) {
    print("\t\t<Entity Type=\"cmlh.rapleaf.gender.male\"><Value>%");
    printf "%.0f", ( $response->{likelihood} * 100 );
    print("</Value>\n");
}

# TODO $response->{gender} is "unknown" i.e. https://www.rapleaf.com/developers/api_docs/utilities#name_to_gender

else {
    print("\t\t<Entity Type=\"cmlh.rapleaf.gender.female\"><Value>%");
    printf "%.0f", ( $response->{likelihood} * 100 );
    print("</Value>\n");
}
print("\t\t\t<AdditionalFields>\n");
print("\t\t\t\t<Field Name=\"gender\">$response->{gender}</Field>\n");
print("\t\t\t\t<Field Name=\"likelihood\">$response->{likelihood}</Field>\n");
print("\t\t\t</AdditionalFields>\n");
print("\t\t</Entity>\n");
print("\t</Entities>\n");

# http://ctas.paterva.com/view/Specification#Message_Wrapper
print("</MaltegoTransformResponseMessage>\n");
print("</MaltegoMessage>\n");

sub query_by_name {

    # Takes an e-mail that has already been hashed by sha1
    # and returns a hash which maps attribute fields onto attributes
    my $name = $_[0];
    my $url =
      "http://api.rapleaf.com/v4/util/name_to_gender/$name?api_key=$API_KEY";
    print STDERR $url . "\n";
    __get_json_response($url);
}

sub __get_json_response {

    # Takes a url and returns a hash mapping attribute fields onto attributes
    # Note that an exception is raised in the case that
    # an HTTP response code other than 200 is sent back
    # The error code and error body are put in the exception's message
    my $json_response = $ua->get( $_[0] );
    $json_response->is_success
      or die 'Error Code: '
      . $json_response->status_line . "\n"
      . 'Error Body: '
      . $json_response;
    $json = JSON->new->allow_nonref;
    my $personalization = $json->decode( $json_response->content )->{answer};
}

=head1 NAME

from_affiliation_facebook-to_rapleaf_gender.pl - "To Rapleaf Gender Maltego Local Transform"

=head1 VERSION

This documentation refers to "To Rapleaf Gender Maltego Local Transform" Alpha $VERSION

=head1 CONFIGURATION

See the associated #CONFIGURATION Tag

Please refer to https://github.com/cmlh/Maltego-Rapleaf/wiki for further information 

=head1 MALTEGO CONFIGURATION

Please refer to https://github.com/cmlh/Maltego-Rapleaf/wiki for further information 

=head1 USAGE

Please refer to https://github.com/cmlh/Maltego-Gravatar/wiki for further information 

=head1 REQUIRED ARGUEMENTS

"Affiliation - Facebook" Entity

=head1 OPTIONAL ARGUEMENTS

=head1 DESCRIPTION

Please refer to https://github.com/cmlh/Maltego-Rapleaf/README.pod

=head1 CONTRIBUTION

Based on the "Apache License 2.0" Perl Code listed at https://raw.github.com/Rapleaf/Personalization-Dev-Kits/master/perl/RapleafApi.pl

=head1 DEPENDENCIES

=head1 PREREQUISITES

https://www.rapleaf.com/developers/api_access

=head1 COREQUISITES

=head1 OSNAMES

osx

=head1 SCRIPT CATEGORIES

Web

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

Please refer to the comments beginning with "TODO" in the Perl Code.

=head1 AUTHOR

Christian Heinrich

=head1 CONTACT INFORMATION

http://cmlh.id.au/contact

=head1 MAILING LIST

=head1 REPOSITORY

https://github.com/cmlh/Maltego-Rapleaf

=head1 FURTHER INFORMATION AND UPDATES

http://cmlh.id.au/tagged/maltego

=head1 LICENSE AND COPYRIGHT

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. 

Copyright 2012 Christian Heinrich