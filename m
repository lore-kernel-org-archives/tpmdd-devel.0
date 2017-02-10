From: "Dr. Greg Wettstein" <greg-DHO+NtfOqB5PEDpkEIzg7wC/G2K4zDHf@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
	exhaustion
Date: Fri, 10 Feb 2017 04:03:51 -0600
Message-ID: <201702101003.v1AA3plF029882@wind.enjellic.com>
References: <James.Bottomley@HansenPartnership.com>
Reply-To: greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
	"Re: [tpmdd-devel] [RFC] tpm2-space: add handling for global session
	exhaustion" (Feb 9, 11:24am)
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Feb 9, 11:24am, James Bottomley wrote:
} Subject: Re: [tpmdd-devel] [RFC] tpm2-space: add handling for global sessi

Good morning to everyone.

> On Thu, 2017-02-09 at 03:06 -0600, Dr. Greg Wettstein wrote:
> > Referring back to Ken's comments about having 20+ clients waiting to
> > get access to the hardware.  Even with the focus in TPM2 on having it
> > be more of a cryptographic accelerator are we convinced that the
> > hardware is ever going to be fast enough for a model of having it
> > directly service large numbers of transactions in something like a
> > 'cloud' model?

> It's already in use as such today:
> 
> https://tectonic.com/assets/pdf/TectonicTrustedComputing.pdf

We are familiar with this work.  I'm not sure, however, that this work
is representative of the notion of using TPM hardware to support a
transactional environment, particularly at the cloud/container level.

There is not a great deal of technical detail on the CoreOS integrity
architecture but it appears they are using TPM hardware to validate
container integrity.  I'm not sure this type of environment reflects
the ability of TPM hardware to support transactional throughputs in an
environment such as financial transaction processing.

Intel's Clear Container work cites the need to achieve container
startup times of 150 milliseconds and they are currently claiming 45
milliseconds as their optimal time.  This work was designed to
demonstrate the feasibility of providing virtual machine isolation
guarantees to containers and as such one of the mandates was to
achieve container start times comparable to standard namespaces.

I ran some very rough timing metrics on one of our Skylake development
systems with hardware TPM2 support.  Here are the elapsed times for
two common verification operations which I assume would be at the
heart of generating any type of reasonable integrity guarantee:

quote: 810 milliseconds
verify signature: 635 milliseconds

This is with the verifying key loaded into the chip.  The elapsed time
to load and validate a key into the chip averages 1200 milliseconds.
Since we are discussing a resource manager which would be shuttling
context into and out of the limited resource slots on the chip I
believe it is valid to consider this overhead as well.

This suggests that just a signature verification on the integrity of a
container is a factor of 4.2 times greater then a well accepted start
time metric for container technology.

Based on that I'm assuming that if TPM based integrity guarantees are
being implemented they are only on ingress of the container into the
cloud environment.  I'm assuming an alternate methodology must be in
place to protect against time of measurement/time of use issues.

Maybe people have better TPM2 hardware then what we have.  I was going
to run this on a Kaby Lake reference system but it appears that TXT is
causing some type of context depletion problems which we we need to
run down.

> We're also planning something like this in the IBM Cloud.

I assume if there is an expection of true transactional times you
either will have better hardware then current generation TPM2
technology.  Either that or I assume you will be using userspace
simulators anchored with a hardware TPM trust root.

Ken's reflection of having 21-22 competing transactions would appear
to have problematic latency issues given our measurements.

I influence engineering for a company which builds deterministically
modeled Linux platforms.  We've spent a lot of time considering TPM2
hardware bottlenecks since they constrain the rate at which we can
validate platform behavioral measurements.

We have a variation of this work which allows SGX OCALL's to validate
platform behavior in order to provide a broader TCB resource spectrum
to the enclave and hardware TPM performance is problematic there as
well.

> James

Have a good weekend.

Greg

}-- End of excerpt from James Bottomley

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org
------------------------------------------------------------------------------
"After being a technician for 2 years, I've discovered if people took
 care of their health with the same reckless abandon as their computers,
 half would be at the kitchen table on the phone with the hospital, trying
 to remove their appendix with a butter knife."
                                -- Brian Jones

-- 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
