#
# Copyright (C) 2013-2014   Ian Firns   <firnsy@kororaproject.org>
#                           Chris Smart <csmart@kororaproject.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
package Website::Contribute;

use warnings;
use strict;

use Mojo::Base 'Mojolicious::Controller';

#
# PERL INCLUDES
#
use Data::Dumper;
use Mojo::JSON qw(j);
use Mojo::Util qw(trim);
use Time::Piece;

#
# LOCAL INCLUDES
#
use Canvas::Store::Contribution;

#
# CONTROLLER HANDLERS
#
sub index_get {
  my $self = shift;

  $self->render('website/contribute');
}

sub developer_get {
  my $self = shift;

  $self->stash( colours => [
    { # cherry
      base   => [255,  68,  68],
      shadow => [204,   0,   0],
    },
    {
      base   => [255, 187,  51],
      shadow => [255, 136,   0],
    },
    {
      base   => [255, 229,  51],
      shadow => [255, 204,   0],
    },
    {
      base   => [ 51, 181, 229],
      shadow => [  0, 153, 204],
    },
#    {
#      base   => [153, 204, 153],
#      shadow => [102, 153, 102],
#    },
    {
      base   => [153, 204,   0],
      shadow => [102, 153,   0],
    },
    {
      base   => [170, 102, 204],
      shadow => [153,  51, 204],
    },
    {
      base   => [153, 153, 153],
      shadow => [ 68,  68,  68],
    },
    { # wood
      base   => [153, 102,  51],
      shadow => [ 68,  51,   0],
    },
  ], colours_alt => [

    {
      base   => [231,  76,  60],
      shadow => [192,  57,  43],
    },
    {
      base   => [230, 126,  34],
      shadow => [211,  84,   0],
    },
    {
      base   => [241, 196,  15],
      shadow => [243, 156,  18],
    },
    {
      base   => [ 26, 188, 156],
      shadow => [ 22, 160, 133],
    },
    {
      base   => [ 46, 204, 113],
      shadow => [ 39, 174,  96],
    },
    {
      base   => [ 52, 152, 219],
      shadow => [ 41, 128, 185],
    },
    {
      base   => [155,  89, 182],
      shadow => [142,  68, 173],
    },
    {
      base   => [ 52,  73,  94],
      shadow => [ 44,  62,  80],
    },
    {
      base   => [149, 165, 166],
      shadow => [127, 140, 141],
    },
    {
      base   => [236, 240, 241],
      shadow => [189, 195, 199],
    },
  ], colours_kde => [
    {
      base   => [191,   3,   3],
      shadow => [156,  15,  15],
    },
    {
      base   => [191,   3,  97],
      shadow => [156,  15,  86],
    },
    {
      base   => [133,   2, 108],
      shadow => [106,   0,  86],
    },
    {
      base   => [ 52,  23, 110],
      shadow => [ 29,  10,  85],
    },
    {
      base   => [  0,  67, 138],
      shadow => [  0,  49, 110],
    },
    {
      base   => [  0,  96, 102],
      shadow => [  0,  72,  77],
    },
    {
      base   => [  0, 115,  77],
      shadow => [  0,  88,   6],
    },
    {
      base   => [  0, 137,  44],
      shadow => [  0, 110,  41],
    },
    {
      base   => [243, 195,   0],
      shadow => [227, 173,   0],
    },
    {
      base   => [207,  73,  19],
      shadow => [172,  67,  17],
    },
    {
      base   => [ 85,  87,  83],
      shadow => [ 46,  52,  54],
    },
    {
      base   => [ 87,  64,  30],
      shadow => [ 56,  37,   9],
    },
  ], colours_tango => [
    {
      other  => [239, 41, 41],
      base   => [204,  0,  0],
      shadow => [164,  0,  0],
    },
    {
      other  => [252,175, 62],
      base   => [245,121,  0],
      shadow => [206, 92,  0],
    },
    {
      other  => [252,233, 79],
      base   => [237,212,  0],
      shadow => [196,160,  0],
    },
    {
      other  => [138,226, 52],
      base   => [115,210, 22],
      shadow => [78,154,  6],
    },
    {
      other  => [114,159,207],
      base   => [52,101,164],
      shadow => [32, 74,135],
    },
    {
      other  => [173,127,168],
      base   => [117, 80,123],
      shadow => [92 ,53,102],
    },
    {
      other  => [233,185,110],
      base   => [193,125, 17],
      shadow => [143, 89,  2],
    },
    {
      other  => [238, 238,236],
      base   => [211, 215,207],
      shadow => [186, 189,182],
    },
    {
      other  => [136, 138, 133],
      base   => [85,   87,  83],
      shadow => [46,   52,  54],
    },
  ] );

  $self->render('website/contribute-developer');
}

sub donate_get {
  my $self = shift;

  my $v = $self->flash('values') // {
    donor_name => '',
    donor_email => '',
    donor_amount => '',
  };

  $self->stash(v => $v);

  $self->render('website/contribute-donate');
}


sub donate_post {
  my $self = shift;

  my $v = {
    donor_name   => $self->param('donor_name')        // 'Anonymous',
    donor_email  => $self->param('donor_email')       // '',
    donor_amount => $self->param('donor_amount')      // '0.00',
  };

  # store entered values for errors
  $self->flash( values => $v );

  # validate the donor email
  unless( $v->{donor_email} =~ m/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/ ) {
    $self->flash(page_errors => "Please enter a valid email address so we can thank you.");
    return $self->redirect_to('contributedonate');
  }

  # validate the donor amount
  unless( $v->{donor_amount}+0 > 0 ) {
    $self->flash(page_errors => "Please specify at least a dollar.");
    return $self->redirect_to('contributedonate');
  }

  # retrieve the PayPal transaction information from the cache
  # and rebuild as required
  my $pp_context = $self->cache->get('pp_context');

  unless( ref $pp_context eq 'Canvas::Util::PayPal' ) {
    $self->app->log->debug('Rebuilding PayPal context ...');
    $pp_context = Canvas::Util::PayPal->new(
      caller_user      => $self->config->{paypal}{caller_user},
      caller_password  => $self->config->{paypal}{caller_password},
      caller_signature => $self->config->{paypal}{caller_signature},
      mode             => $self->config->{paypal}{mode},
    );

    $self->cache->set(pp_context => $pp_context);
  };

  my $pp_donation = $pp_context->donate_prepare( $v->{donor_amount} );

  $self->session(
    donor_name  => $v->{donor_name},
    donor_email => $v->{donor_email}
  );

  # redirect to donation unless we have success
  unless( lc $pp_donation->{ACK} eq 'success' ) {
    return $self->redirect_to('contributedonate');
  }

  # redirect to paypal for authorisation
  $self->redirect_to('https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=' . $pp_donation->{TOKEN} );
}

sub donate_confirm_get {
  my $self = shift;

  my $token = $self->param('token');

  # no point being here without a token
  return $self->redirect_to('contributedonate') unless $token;

  # retrieve the PayPal transaction information from the cache
  # and rebuild as required
  my $pp_context = $self->cache->get('pp_context');

  unless( ref $pp_context eq 'Canvas::Util::PayPal' ) {
    $self->app->log->debug('Rebuilding PayPal context ...');
    $pp_context = Canvas::Util::PayPal->new(
      caller_user      => $self->config->{paypal}{caller_user},
      caller_password  => $self->config->{paypal}{caller_password},
      caller_signature => $self->config->{paypal}{caller_signature},
      mode             => $self->config->{paypal}{mode},
    );

    $self->cache->set(pp_context => $pp_context);
  };

  my $pp_details = $pp_context->donate_confirm( $token );

  # abort if we didn't successfully retrieve the donation details
  unless( lc $pp_details->{ACK} eq 'success' ) {
    $self->flash(page_errors => "An error occured processing your donation. You have not been charged and we are investigating the issue.");

    return $self->redirect_to('contributedonate');
  }

  $self->stash(
    amount   => $pp_details->{PAYMENTREQUEST_0_AMT},
    currency => $pp_details->{CURRENCYCODE},
    payerid  => $pp_details->{PAYERID},
    token    => $pp_details->{TOKEN},
    name     => $self->session('donor_name'),
    email    => $self->session('donor_email'),
  );

  $self->render('website/contribute-donate-confirm');
}

sub donate_confirm_post {
  my $self = shift;

  my $token   = $self->param('token');
  my $payerid = $self->param('payerid');
  my $amount  = $self->param('amount');
  my $name    = $self->param('name');
  my $email   = $self->param('email');

  # validate the token
  unless( length $token == 20 ) {
    $self->flash(page_errors => "Invalid TOKEN supplied by PayPal.");
    return $self->redirect_to('contributedonate');
  }

  # validate the payerid
  unless( $payerid =~ /[A-Za-z0-9]{13}/ ) {
    $self->flash(page_errors => "Invalid PAYER ID supplied by PayPal.");
    return $self->redirect_to('contributedonate');
  }

  # retrieve the PayPal transaction information from the cache
  # and rebuild as required
  my $pp_context = $self->cache->get('pp_context');

  unless( ref $pp_context eq 'Canvas::Util::PayPal' ) {
    $self->app->log->debug('Rebuilding PayPal context ...');
    $pp_context = Canvas::Util::PayPal->new(
      caller_user      => $self->config->{paypal}{caller_user},
      caller_password  => $self->config->{paypal}{caller_password},
      caller_signature => $self->config->{paypal}{caller_signature},
      mode             => $self->config->{paypal}{mode},
    );

    $self->cache->set(pp_context => $pp_context);
  };

  my $pp_donation = $pp_context->donate_commit( $token, $payerid, $amount );

  # check payment state
  if( lc $pp_donation->{ACK} eq 'success' &&
      lc $pp_donation->{PAYMENTINFO_0_ACK} eq 'success' ) {
    # reset flash values
    #$self->flash( values => {} );
    $self->flash(page_success => "Thank you for your donation. Korora will only get better with your contribution.");

    my $created = Time::Piece->strptime( $pp_donation->{PAYMENTINFO_0_ORDERTIME}, '%Y-%m-%dT%H:%M:%SZ' );

    my $d = Canvas::Store::Contribution->create({
      type           => 'donation',
      merchant_id    => $pp_donation->{PAYMENTINFO_0_SECUREMERCHANTACCOUNTID},
      transaction_id => $pp_donation->{PAYMENTINFO_0_TRANSACTIONID},
      amount         => $pp_donation->{PAYMENTINFO_0_AMT},
      fee            => $pp_donation->{PAYMENTINFO_0_FEEAMT},
      name           => $name,
      email          => $email,
      paypal_raw     => j($pp_donation),
      created        => $created,
    });
  }
  else {
    $self->flash(page_errors => "Your transaction could not be completed. Nothing has been charged to your account.");

    # TODO: remove
    say Dumper $pp_donation;
  }

  $self->redirect_to('contributedonate');
}

sub sponsor_get {
  my $self = shift;

  my $v = $self->flash('values') // {
    donor_name => '',
    donor_email => '',
    donor_amount => '',
  };

  $self->stash(v => $v);

  $self->render('website/contribute-sponsor');
}


sub sponsor_post {
  my $self = shift;

  my $v = {
    sponsor_name   => $self->param('sponsor_name')        // 'Anonymous',
    sponsor_email  => $self->param('sponsor_email')       // '',
    sponsor_amount => $self->param('sponsor_amount')      // '0.00',
  };

  # store entered values for errors
  $self->flash( values => $v );

  # validate the donor email
  unless( $v->{sponsor_email} =~ m/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/ ) {
    $self->flash(page_errors => "Please enter a valid email address so we can thank you.");
    return $self->redirect_to('contributesponsor');
  }

  # validate the donor amount
  unless( $v->{sponsor_amount}+0 > 0 ) {
    $self->flash(page_errors => "Please specify at least a dollar.");
    return $self->redirect_to('contributesponsor');
  }

  # retrieve the PayPal transaction information from the cache
  # and rebuild as required
  my $pp_context = $self->cache->get('pp_context');

  unless( ref $pp_context eq 'Canvas::Util::PayPal' ) {
    $self->app->log->debug('Rebuilding PayPal context ...');
    $pp_context = Canvas::Util::PayPal->new(
      caller_user      => $self->config->{paypal}{caller_user},
      caller_password  => $self->config->{paypal}{caller_password},
      caller_signature => $self->config->{paypal}{caller_signature},
      mode             => $self->config->{paypal}{mode},
    );

    $self->cache->set(pp_context => $pp_context);
  };

  my $pp_sponsorship = $pp_context->sponsor_prepare( $v->{sponsor_amount} );

  $self->session(
    sponsor_name  => $v->{sponsor_name},
    sponsor_email => $v->{sponsor_email},
    sponsor_amount => $v->{sponsor_amount}
  );

  # redirect to donation unless we have success
  unless( lc $pp_sponsorship->{ACK} eq 'success' ) {
    return $self->redirect_to('contributesponsor');
  }

  # redirect to paypal for authorisation
  $self->redirect_to('https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=' . $pp_sponsorship->{TOKEN} );
}

sub sponsor_confirm_get {
  my $self = shift;

  my $token = $self->param('token');

  # no point being here without a token
  return $self->redirect_to('contributesponsor') unless $token;

  # retrieve the PayPal transaction information from the cache
  # and rebuild as required
  my $pp_context = $self->cache->get('pp_context');

  unless( ref $pp_context eq 'Canvas::Util::PayPal' ) {
    $self->app->log->debug('Rebuilding PayPal context ...');
    $pp_context = Canvas::Util::PayPal->new(
      caller_user      => $self->config->{paypal}{caller_user},
      caller_password  => $self->config->{paypal}{caller_password},
      caller_signature => $self->config->{paypal}{caller_signature},
      mode             => $self->config->{paypal}{mode},
    );

    $self->cache->set(pp_context => $pp_context);
  };

  my $pp_details = $pp_context->sponsor_confirm( $token );

  # abort if we didn't successfully retrieve the donation details
  unless( lc $pp_details->{ACK} eq 'success' ) {
    $self->flash(page_errors => "An error occured processing your donation. You have not been charged and we are investigating the issue.");

    return $self->redirect_to('contributesponsor');
  }

  $self->stash(
    currency => $pp_details->{CURRENCYCODE},
    payerid  => $pp_details->{PAYERID},
    token    => $pp_details->{TOKEN},
    name     => $self->session('sponsor_name'),
    email    => $self->session('sponsor_email'),
    amount   => $self->session('sponsor_amount'),
  );

  $self->session(
    payerid  => $pp_details->{PAYERID},
    amount   => $self->session('sponsor_amount'),
  );

  $self->render('website/contribute-sponsor-confirm');
}

sub sponsor_confirm_post {
  my $self = shift;

  my $token   = $self->param('token');
  my $payerid = $self->param('payerid');
  my $amount  = $self->param('amount');
  my $name    = $self->param('name');
  my $email   = $self->param('email');

  # validate the token
  unless( length $token == 20 ) {
    $self->flash(page_errors => "Invalid TOKEN supplied by PayPal.");
    return $self->redirect_to('contributesponsor');
  }

  # validate the payerid
  unless( $payerid =~ /[A-Za-z0-9]{13}/ ) {
    $self->flash(page_errors => "Invalid PAYER ID supplied by PayPal.");
    return $self->redirect_to('contributesponsor');
  }

  # retrieve the PayPal transaction information from the cache
  # and rebuild as required
  my $pp_context = $self->cache->get('pp_context');

  unless( ref $pp_context eq 'Canvas::Util::PayPal' ) {
    $self->app->log->debug('Rebuilding PayPal context ...');
    $pp_context = Canvas::Util::PayPal->new(
      caller_user      => $self->config->{paypal}{caller_user},
      caller_password  => $self->config->{paypal}{caller_password},
      caller_signature => $self->config->{paypal}{caller_signature},
      mode             => $self->config->{paypal}{mode},
    );

    $self->cache->set(pp_context => $pp_context);
  };

  my $pp_sponsorship = $pp_context->sponsor_commit( $token, $payerid, $amount );

  # check payment state
  if( lc $pp_sponsorship->{ACK} eq 'success' &&
      lc $pp_sponsorship->{PROFILESTATUS} eq 'activeprofile' ) {
    # reset flash values
    #$self->flash( values => {} );
    $self->flash(page_success => "Thank you for your sponsorship. Korora will only get better with your contribution. We will follow up with you shortly.");

    #my $created = Time::Piece->strptime( $pp_sponsorship->{PAYMENTINFO_0_ORDERTIME}, '%Y-%m-%dT%H:%M:%SZ' );
    my $created = gmtime;

    my $d = Canvas::Store::Contribution->create({
      type           => 'sponsorship',
      merchant_id    => $self->session('payerid'),
      transaction_id => $pp_sponsorship->{PROFILEID},
      amount         => $self->session('amount'),
      fee            => 0,
      name           => $name,
      email          => $email,
      paypal_raw     => j($pp_sponsorship),
      created        => $created,
    });
  }
  else {
    $self->flash(page_errors => "Your transaction could not be completed. Nothing has been charged to your account.");

    # TODO: remove
    say Dumper $pp_sponsorship;
  }

  $self->redirect_to('contributesponsor');
}

1;
