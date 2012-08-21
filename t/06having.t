# Tests an undocumented feature.
# I'm not sure the 'having' plugin is even a good idea.

use Test::More tests => 1;
use MooseX::DeclareX plugins => [qw(having)];

class Monkey having name
{
	has sleeping => (is => 'rw', isa => 'Bool', required => 1);
	method screech ($sound) {
		return $self->name . q[: ] . $sound;
	}
}

for ( Monkey->new(sleeping => 0, name => 'Bob') )
{
	ok (
		$_->screech('Eee!'),
		'Bob: Eee!',
	);
}
