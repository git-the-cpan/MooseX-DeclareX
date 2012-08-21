package MooseX::DeclareX::Plugin::public;

BEGIN {
	$MooseX::DeclareX::Plugin::public::AUTHORITY = 'cpan:TOBYINK';
	$MooseX::DeclareX::Plugin::public::VERSION   = '0.001';
}

use Moose;
with 'MooseX::DeclareX::Plugin';

use MooseX::Declare ();
use Moose::Util ();

sub plugin_setup
{
	my ($class, $kw) = @_;
	
	Moose::Util::apply_all_roles(
		$kw,
		'MooseX::DeclareX::Plugin::public::Role',
	)
		if $kw->can('add_namespace_customizations');
}

package MooseX::DeclareX::Plugin::public::Role;

BEGIN {
	$MooseX::DeclareX::Plugin::public::Role::AUTHORITY = 'cpan:TOBYINK';
	$MooseX::DeclareX::Plugin::public::Role::VERSION   = '0.001';
}

use Moose::Role;

after add_namespace_customizations => sub 
{
	my ($self, $ctx, $package, $attribs) = @_;
	$ctx->add_scope_code_parts(
		"BEGIN { MooseX::DeclareX::Plugin::public::Parser->import() }",
	);
	return 1;
};

package MooseX::DeclareX::Plugin::public::Parser;

BEGIN {
	$MooseX::DeclareX::Plugin::public::Parser::AUTHORITY = 'cpan:TOBYINK';
	$MooseX::DeclareX::Plugin::public::Parser::VERSION   = '0.001';
}

use Moose;
extends 'MooseX::DeclareX::MethodPrefix';

override prefix_keyword => sub { 'public' };
override install_method => sub {
	my ($self, $method) = @_;
	Class::MOP::class_of( $method->package_name )
		->add_method($method->name, $method);
};

1;

