package App::Changelog;

use strict;
use warnings;

use feature 'say';

our $VERSION = '1.0.0';

sub new {
    my ( $class, %args ) = @_;
    my $self = {
        output_file => $args{output_file} || 'CHANGELOG.md',
        compact     => $args{compact} // 1,
        filter_tag  => $args{filter_tag} || '',
    };
    bless $self, $class;
    return $self;
}

sub generate_changelog {
    my ($self) = @_;

    say "Generating changelog from Git history...";

    my $git_log_format =
      $self->{compact} ? '--pretty=format:"%h %s"' : '--pretty=fuller';
    my $git_log =
      $self->_run_git_command("git log $git_log_format --abbrev-commit");
    if ( !$git_log ) {
        die
"Error: Could not retrieve Git history. Are you in a Git repository?\n";
    }

    my @tags = $self->_get_tags();
    my $changelog_content =
      $self->_build_changelog_content( \@tags, $git_log_format );

    $self->_write_to_file($changelog_content);
    say "Changelog generated successfully in $self->{output_file}.";
}

sub _get_tags {
    my ($self)   = @_;
    my $git_tags = $self->_run_git_command('git tag --sort=creatordate');
    my @tags     = split( /\n/, $git_tags );
    if ( !@tags ) {
        die
"Error: No Git tags found. Use 'git tag' to create version tags first.\n";
    }

    if ( $self->{filter_tag} ) {
        @tags = grep { /^$self->{filter_tag}/ } @tags;
        if ( !@tags ) {
            die "Error: No tags matching the filter '$self->{filter_tag}'.\n";
        }
    }
    return @tags;
}

sub _build_changelog_content {
    my ( $self, $tags, $format ) = @_;
    my $content = "# Changelog\n\n";

    for my $i ( 0 .. $#$tags ) {
        my $current_tag  = $tags->[$i];
        my $previous_tag = $i == $#$tags ? '' : $tags->[ $i + 1 ];

        my $log_command =
          $previous_tag
          ? "git log $previous_tag..$current_tag $format"
          : "git log $current_tag $format";

        my $logs = $self->_run_git_command($log_command);

        my $date =
          $self->_run_git_command("git log -1 --format=%ai $current_tag");
        $date =~ s/\s.*$//;

        $content .= "## [$current_tag] - $date\n\n";
        $content .= "$logs\n" if $logs;
    }

    return $content;
}

sub _run_git_command {
    my ( $self, $command ) = @_;
    my $output = `$command`;
    chomp $output;
    return $output;
}

sub _write_to_file {
    my ( $self, $content ) = @_;
    open( my $fh, '>', $self->{output_file} )
      or die "Could not open $self->{output_file}: $!";
    print $fh $content;
    close($fh);
}

1;
