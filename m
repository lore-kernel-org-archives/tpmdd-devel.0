From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Thu, 9 Feb 2017 17:19:22 +0200
Message-ID: <20170209151922.cqo32h4io5dqyvvw@intel.com>
References: <jarkko.sakkinen@linux.intel.com>
	<201702090906.v1996c6a015552@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201702090906.v1996c6a015552-DHO+NtfOqB5PEDpkEIzg7wC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 09, 2017 at 03:06:38AM -0600, Dr. Greg Wettstein wrote:
> On Jan 30, 11:58pm, Jarkko Sakkinen wrote:
> } Subject: Re: [tpmdd-devel] [RFC] tpm2-space: add handling for global sessi
> 
> Good morning, I hope the day is going well for everyone.
> 
> > I'm kind dilating to an opinion that we would leave this commit out
> > from the first kernel release that will contain the resource manager
> > with similar rationale as Jason gave me for whitelisting: get the
> > basic stuff in and once it is used with some workloads whitelisting
> > and exhaustion will take eventually the right form.
> >
> > How would you feel about this?
> 
> I wasn't able to locate the exact context to include but we noted with
> interest Ken's comments about his need to support a model where a
> client needs a TPM session for transaction purposes which can last a
> highly variable amount of time.  That and concerns about command
> white-listing, hardware denial of service and related issues tend to
> underscore our concerns about how much TPM resource management should
> go into the kernel.
> 
> Once an API is in the kernel we live with it forever.  Particularly
> with respect to TPM2, our field experiences suggest it is way too
> early to bake long term functionality into the kernel.
> 
> Referring back to Ken's comments about having 20+ clients waiting to
> get access to the hardware.  Even with the focus in TPM2 on having it
> be more of a cryptographic accelerator are we convinced that the
> hardware is ever going to be fast enough for a model of having it
> directly service large numbers of transactions in something like a
> 'cloud' model?

I doubt it. Personally I would rather just limit the number of
connections to /dev/tpms0 than have a complex lease model (like one
implemented in this commit). That could have '0' setting, which would
disable it so that it doesn't cause harm to those who do not need it.

> The industry has very solid userspace implementations of TPM2.  It
> seems that with respect to resource management about all we would want
> in the kernel is enough management to allow multiple privileged
> userspace process to establish a root of trust for a TPM2 based
> userspace instance with subsequent relinquishment of privilege.  At
> that point one has the freedom to implement all sorts of policy.

If you look at the patch set that I sent yesterday it exactly has a
feature that makes it more lean for a privileged process to implement
a resource manager.

> Given the potential lifespan of these security technologies I think a
> kernel design needs to factor in the availability of trusted execution
> environment's such as SGX as well.  Politics aside, such environments
> do have the ability to significantly modify the guarantees which can
> be afforded to architectural models which focus on using the hardware
> TPM as a root of trust for userspace implementations of 'TPM'
> functionality and policy.

Agreed.

> We can always add functionality to the kernel but we can never
> subtract.  It is way too early to lock security architecture decisions
> into the kernel.

The current patch set does not define policy. The simple policy
addition that could be added soon is the limit of connections
because it is easy to implement in non-intrusive way.

> 
> > /Jarkko
> 
> Have a good weekend.
> 
> Greg

Likewise!

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
