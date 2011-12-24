use strictures;

package CPANRSS;

use Test::More;
use Test::Fatal;

use utf8;
use File::Slurp qw' write_file  ';
use Text::Xslate;
use Encode qw(encode_utf8);

test_template_inputs();
done_testing;

sub test_template_inputs {
    my $name = encode_utf8 "a äüö ☃";

    my $works = Text::Xslate->new->render_string( 'wagh: <: $name :>', { name => $name } );
    ok !exception { write_file 'test_result_works', { binmode => ':raw' }, $works }, "template from perl string";

    my $template = join "\n", <DATA>;
    my $still_works = Text::Xslate->new->render_string( encode_utf8 $template, { name => $name } );
    ok !exception { write_file 'test_result_still_works', { binmode => ':raw' }, $still_works },
      "template from utf8-encoded data file handle";

    my $broken = Text::Xslate->new->render_string( $template, { name => $name } );
    ok !exception { write_file 'test_result_broken', { binmode => ':raw' }, $broken },
      "template from raw data file handle";
}

1;

__DATA__
wagh : <: $name :>
