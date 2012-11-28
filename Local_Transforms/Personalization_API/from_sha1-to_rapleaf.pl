#!/usr/bin/env perl
#
# Forked from https://github.com/Rapleaf/Personalization-Dev-Kits/blob/master/perl/RapleafApi.pl

use LWP::UserAgent;
use JSON;
use Digest::SHA1;
use URI::Escape;
use Config::Std;
# use Smart::Comments;

my $VERSION = "0.0.2"; # May be required to upload script to CPAN i.e. http://www.cpan.org/scripts/submitting.html

# CONFIGURATION
# REFACTOR with "easydialogs" e.g. http://www.paterva.com/forum//index.php/topic,134.0.html as recommended by Andrew from Paterva
read_config './etc/Personalization_API.conf' => my %config;
my $API_KEY = $config{'PersonalizationAPI'}{'api_key'};

$ua = LWP::UserAgent->new;

# $ua->timeout(2);
$ua->agent("RapleafApi/Perl/1.1");

my $maltego_selected_entity_value = $ARGV[0];

my $response = query_by_sha1($maltego_selected_entity_value);

# "###" is for "Smart::Comments CPAN Module
### \$response->{location} is :$response->{location}
### \$response->{gender} is :$response->{gender}

# http://ctas.paterva.com/view/Specification#Message_Wrapper
print("<MaltegoMessage>\n");
print("<MaltegoTransformResponseMessage>\n");
print("<UIMessages>\n");
print(
"		<UIMessage MessageType=\"Inform\">To Rapleaf (Basic) - Local Transform v$VERSION</UIMessage>\n"
);

# http://ctas.paterva.com/view/Specification#Entity_definition
if ( $response->{location} eq undef ) {
    print(
"		<UIMessage MessageType=\"PartialError\">No Rapleaf entry for $maltego_selected_entity_value</UIMessage>\n"
    );
    print("</UIMessages>\n");
    print("\t<Entities>\n");
    print("\t</Entities>\n");
}
else {
    print("</UIMessages>\n");
    print("\t<Entities>\n");
    print(
"\t\t<Entity Type=\"maltego.Location\"><Value>$response->{location}</Value></Entity>\n"
    );
    if ( $response->{gender} eq "Male" ) {
        print(
"\t\t<Entity Type=\"maltego.Male\"><Value>$response->{gender}</Value></Entity>\n"
        );
    }
    else {
        print(
"\t\t<Entity Type=\"maltego.Female\"><Value>$response->{gender}</Value></Entity>\n"
        );
    }
    print("\t</Entities>\n");
}

# http://ctas.paterva.com/view/Specification#Message_Wrapper
print("</MaltegoTransformResponseMessage>\n");
print("</MaltegoMessage>\n");

sub query_by_sha1 {

    # Takes an e-mail that has already been hashed by sha1
    # and returns a hash which maps attribute fields onto attributes
    my $sha1_email = $_[0];
    my $url =
        'https://personalize.rapleaf.com/v4/dr?api_key=' 
      . $API_KEY
      . '&sha1_email='
      . uri_escape($sha1_email);
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
    my $personalization = $json->decode( $json_response->content );
}

=head1 NAME

rapleaf-sha1-maltego-local-transform.pl - "Rapleaf - SHA-1 - Maltego Local Transform"

=head1 VERSION

This documentation refers to "Rapleaf - SHA-1 - Maltego Local Transform" Alpha $VERSION

=head1 CONFIGURATION

See the associated #CONFIGURATION Tag

Please refer to https://github.com/cmlh/Maltego-Rapleaf/wiki for further information 

=head1 MALTEGO CONFIGURATION

Please refer to https://github.com/cmlh/Maltego-Rapleaf/wiki for further information 

=head1 USAGE

Please refer to https://github.com/cmlh/Maltego-Gravatar/wiki for further information 

=head1 REQUIRED ARGUEMENTS

$1 i.e. "SHA-1" Entity i.e. https://github.com/cmlh/Maltego-Crypto/blob/master/Entities-Crypto.mtgx

=head1 OPTIONAL ARGUEMENTS

=head1 DESCRIPTION

Please refer to https://github.com/cmlh/Maltego-Rapleaf/README.pod

=head1 CONTRIBUTION

Based on the "Apache License 2.0" Perl Code listed at https://raw.github.com/Rapleaf/Personalization-Dev-Kits/master/perl/RapleafApi.pl

=head1 DEPENDENCIES

=head1 PREREQUISITES

Importation of the:
1. "Male" and "Female" Entities from Casefile i.e. http://www.paterva.com/web5/casefile/casefile_entities.mtz
2. "SHA-1" Entity i.e. https://github.com/cmlh/Maltego-Crypto/blob/master/Entities-Crypto.mtgx

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
