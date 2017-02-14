From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Tue, 14 Feb 2017 08:47:16 -0800
Message-ID: <1487090836.3133.33.camel@HansenPartnership.com>
References: <201702101003.v1AA3plF029882@wind.enjellic.com>
	<1486745163.2502.26.camel@HansenPartnership.com>
	<OFA049276F.2B32440E-ON852580C3.00742287-852580C3.00748E6B@notes.na.collabserv.com>
	<20170214143829.GA28175@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170214143829.GA28175-DHO+NtfOqB5PEDpkEIzg7wC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Dr. Greg Wettstein" <gw-0TOP4RXranlg9hUCZPvPmw@public.gmane.org>, Kenneth Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 2017-02-14 at 08:38 -0600, Dr. Greg Wettstein wrote:
> On Fri, Feb 10, 2017 at 04:13:05PM -0500, Kenneth Goldman wrote:
> 
> Good morning to everyone.
> 
> > James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote on 
> > 02/10/2017 11:46:03 AM:
> > 
> > > > quote: 810 milliseconds
> > > > verify signature: 635 milliseconds
> 
> For those who may be interested in this sort of thing I grabbed a few
> minutes and ran these basic verification primitives against a Kaby
> Lake system.
> 
> Average time for a quote is 600 milliseconds with a signature
> verification clocking in at 100 milliseconds.  The latter is
> consistent with what James found on his Skylake machine.
> 
> Latencies are still significant with things like container start
> times.
> 
> > > Part of the way of reducing the latency is not to use the TPM for
> > > things that don't require secrecy: 
> 
> > Agreed.  There are a few times one would verify a signature inside 
> > the TPM, but they're far from mainstream:
> > 
> > 1 - Early in the boot cycle, when there's no crypto library.
> > 
> > 2 - When the crypto library doesn't support the required algorithm.
> > 
> > 3 - When a ticket is needed to prove to the TPM later that it
> > verified
> > the signature.
> 
> I don't think there is any doubt that running cryptographic 
> primitives in userspace is going to be faster then going to hardware.
>   Obviously that also means there is no need for a TPM resource 
> manager which has been the subject of much discussion here.

That's a bit of a non-sequitur.  Ken's and my point was that although
you could run every crypto operation through the TPM, you don't (as you
say, because it's too slow), so you carefully select the ones that
preserve the confidentiality you're looking for.  To take the VPNaaS
use case again: the key material you're protecting is the client
identity key, so the only crypto operation you run through the TPM is
creation of the TLS client certificate verification signature. 
 Everything else, including the server certificate signature 
 verification, the symmetric key agreement and all the symmetric
encryption operations, you keep in userspace.  That means that instead
of requiring thousands of crypto operations per second from the TPM,
you basically require about one per hour per VPNaaS instance.

We need a RM because without one, given the constraints of TPM2, as few
as two VPNaaS instances can cause a resource exhaustion failure.

James

> The CoreOS paper makes significant reference to increased security
> guarantees inherent in the use of a TPM.  Obviously whatever uses
> those are will have the noted latency constraints.
> 
> We have extended our behavior measurement verifications to the
> container level so we offer an explicit guarantee that a container 
> has not operated in a manner which is inconsistent with the intent of 
> its designer.  Getting the security guarantee we need requires that 
> an linkage to a hardware root of trust hence our concerns about 
> hardware latency.
> 
> Have a good day.
> 
> As always,
> Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
> 4206 N. 19th Ave.           Specializing in information infra
> -structure
> Fargo, ND  58102            development.
> PH: 701-281-1686
> FAX: 701-281-3949           EMAIL: greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org
> ---------------------------------------------------------------------
> ---------
> "UNIX is simple and coherent, but it takes a genious (or at any rate,
>  a programmer) to understand and appreciate its simplicity."
>                                 -- Dennis Ritchie
>                                    USENIX '87
> 


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
