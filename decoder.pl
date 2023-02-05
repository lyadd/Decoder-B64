base64decode() {
   perl -e 'use MIME::Base64 qw(decode_base64);$/=undef;print decode_base64(<>);'
}
