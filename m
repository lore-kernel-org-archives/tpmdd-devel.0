From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Thu, 09 Feb 2017 12:05:50 -0800
Message-ID: <1486670750.2616.55.camel@HansenPartnership.com>
References: <201702090906.v1996c6a015552@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <201702090906.v1996c6a015552-DHO+NtfOqB5PEDpkEIzg7wC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-02-09 at 03:06 -0600, Dr. Greg Wettstein wrote:
> On Jan 30, 11:58pm, Jarkko Sakkinen wrote:
> } Subject: Re: [tpmdd-devel] [RFC] tpm2-space: add handling for
> global sessi
> 
> Good morning, I hope the day is going well for everyone.
> 
> > I'm kind dilating to an opinion that we would leave this commit out
> > from the first kernel release that will contain the resource 
> > manager with similar rationale as Jason gave me for whitelisting: 
> > get the basic stuff in and once it is used with some workloads 
> > whitelisting and exhaustion will take eventually the right form.
> > 
> > How would you feel about this?
> 
> I wasn't able to locate the exact context to include but we noted 
> with interest Ken's comments about his need to support a model where 
> a client needs a TPM session for transaction purposes which can last 
> a highly variable amount of time.  That and concerns about command
> white-listing, hardware denial of service and related issues tend to
> underscore our concerns about how much TPM resource management should
> go into the kernel.
> 
> Once an API is in the kernel we live with it forever.

This actually is far too strong a statement:  Once you make API
guarantees, you have to live with them forever, but there's a
considerable difference between an API guarantee and the API itself. 
 For instance the kernel overlay filesystem has gone through several
iterations of file whiteouts (showing a file as deleted above a read
only copy): we began with an inode flag, moved to an extended attribute
and finally ended up with a device.  Each of those three changes was
fairly radical to the VFS API, but didn't fundamentally alter the API
guarantee (that users wouldn't see a file after it was deleted on an
overlay).

The API guarantee /dev/tpms0 is adding is that you won't see TPM out of
memory errors based on what other people are doing, so I think it's a
simple isolation guarantee we can live with long term.  I think that's
a solidly defensible one.

However, right at the moment the guarantee isn't that you won't be
affcted by *anything* another user does, so it's a weak guarantee: you
will see uncorrectable regapping errors based on what others are doing
and you will see global session exhaustion.

I think we begin with the defensible weak guarantee and discuss how to
strengthen it.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
