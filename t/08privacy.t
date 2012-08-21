use Test::More tests => 8;
use Test::Exception;
use MooseX::DeclareX plugins => [qw(private public protected)];

class Local
{
	private method priv {
		return 99;
	}
	public method pub {
		$self->priv + 1;
	}
	protected method prot {
		return $self->priv + 2;
	}
}

class Local::Sub extends Local
{
	method priv_sub {
		return $self->priv + 3;
	}
	method prot_sub {
		return $self->prot + 4;
	}
}

my $x = Local->new;
my $y = Local::Sub->new;

throws_ok { $x->priv } qr{Local::priv method is private};
throws_ok { $y->priv } qr{Local::priv method is private};
throws_ok { $x->prot } qr{Local::prot method is protected};
throws_ok { $y->prot } qr{Local::prot method is protected};
throws_ok { $y->priv_sub } qr{Local::priv method is private};

lives_and { is($x->pub, 100) };
lives_and { is($y->pub, 100) };
lives_and { is($y->prot_sub, 105) };

