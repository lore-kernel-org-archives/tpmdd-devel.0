From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2] tpm: Factor out common startup code
Date: Thu, 19 May 2016 12:07:14 +0300
Message-ID: <20160519090714.GA12092@intel.com>
References: <1463423147-9874-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<20160517041557.GA29299@intel.com>
	<20160517165304.GA19976@obsidianresearch.com>
	<20160518095924.GA7177@intel.com>
	<20160518171320.GA15170@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160518171320.GA15170-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 18, 2016 at 11:13:20AM -0600, Jason Gunthorpe wrote:
> On Wed, May 18, 2016 at 12:59:24PM +0300, Jarkko Sakkinen wrote:
> > On Tue, May 17, 2016 at 10:53:04AM -0600, Jason Gunthorpe wrote:
> > > On Tue, May 17, 2016 at 07:15:57AM +0300, Jarkko Sakkinen wrote:
> > > > On Mon, May 16, 2016 at 12:25:47PM -0600, Jason Gunthorpe wrote:
> > > > > Provide some flags in tpm_class_ops to allow drivers to opt-in to the
> > > > > common startup sequence. This is the sequence used by tpm_tis and
> > > > > tpm_crb.
> > > > > 
> > > > > All drivers should set this flag.
> > > > 
> > > > The commit message should be a much much more verbose I cannot include
> > > > this without a better explanation. Please update this for the next
> > > > revision.
> > > 
> > > What more description do you want to see?
> > 
> > It is lacking a lot of relevant information:
> > 
> > * It should explain what you mean by startup sequence".
> > * It should describe the constant TPM_OPS_AUTO_STARTUP
> > * It should explain what drivers are doing at the moment (before
> >   this feature).
> > * It should explain what is the benefit for different HW drivers
> >   after applying this patch.
> > * It should explain why you call the executed sequence "automatic"
> >   and also use the word "standard". Yeah, I didn't understand this,
> >   this not me being picky. Maybe it should be DEFAULT_STARTUP??
> 
> Well, use something like this then. You can edit descriptions to your
> liking when you apply the patch, FWIW.
> 
> tpm: Factor out common startup code
> 
> The TCG standard startup sequence (get timeouts, tpm startup, etc) for
> TPM and TPM2 chips is being open coded in many drivers, move it into
> the core code.
> 
> tpm_tis and tpm_crb are used as the basis for the core code
> implementation and the easy drivers are converted. In the process
> several small drivers bugs relating to error handling this flow
> are fixed.
> 
> For now the flag TPM_OPS_AUTO_STARTUP is optional to allow a staged
> driver roll out, but ultimately all drivers should use this flow and
> the flag removed. Some drivers still do not implement the startup
> sequence at all and will need to be tested with it enabled.

This is so much better! Thank you.

I can always edit a description but I do not want completely rewrite
them :)

/Jarkko

------------------------------------------------------------------------------
Mobile security can be enabling, not merely restricting. Employees who
bring their own devices (BYOD) to work are irked by the imposition of MDM
restrictions. Mobile Device Manager Plus allows you to control only the
apps on BYO-devices by containerizing them, leaving personal data untouched!
https://ad.doubleclick.net/ddm/clk/304595813;131938128;j
