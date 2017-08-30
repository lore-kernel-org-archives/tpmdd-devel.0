From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RESEND 3/3] tpm-chip: Export TPM device to
 user space even when startup failed
Date: Wed, 30 Aug 2017 13:26:30 +0300
Message-ID: <20170830102630.uvub5aetqbgww5z4@linux.intel.com>
References: <20170824083714.10016-1-Alexander.Steffen@infineon.com>
 <20170824083714.10016-4-Alexander.Steffen@infineon.com>
 <20170825172021.lw3ycxqw63ubrcm2@linux.intel.com>
 <adaaeae32ba64d979abfc4b758c63fc0@MUCSE603.infineon.com>
 <20170829125509.55aylht3ikes3bpy@linux.intel.com>
 <20170829151739.315ae581@kitsune.suse.cz>
 <E1DD9935-818F-456B-98B3-2103A6799E27@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E1DD9935-818F-456B-98B3-2103A6799E27@gmx.de>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, g@linux.intel.com
Cc: tpmdd-devel@lists.sourceforge.net, Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 29, 2017 at 03:53:17PM +0200, Peter Huewe wrote:
> Thabks Michal!
> 
> Am 29. August 2017 15:17:39 MESZ schrieb "Michal Suchánek" <msuchanek@suse.de>:
> >Hello,
> >
> >On Tue, 29 Aug 2017 15:55:09 +0300
> >Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> >
> >> On Mon, Aug 28, 2017 at 05:15:58PM +0000,
> >> Alexander.Steffen@infineon.com wrote:
> >> > But is that just because nobody bothered to implement the necessary
> >> > logic or for some other reason?  
> >> 
> >> We do not want user space to access broken hardware. It's a huge risk
> >> for system stability and potentially could be used for evil purposes.
> >> 
> >> This is not going to mainline as it is not suitable for general
> >> consumption. You must use a patched kernel if you want this.
> >> 
> >> /Jarkko
> >> 
> >
> >It has been pointed out that userspace applications that use direct IO
> >access exist for the purpose. So using a kernel driver is an
> >improvement over that if the interface is otherwise sane.
> +1
> 
> >
> >What do you expect is the potential for instability or evil use?
> >
> >With a kernel driver arbitrating the bus access as it would in any
> >other case I do not see much potential for instability. 
> 
> Exactly.
>  
> 
> >If there are
> >cases when the arbitration fails they can surely be more likely
> >triggered in cases other than userspace sending arbitrary requests to a
> >device which is in a state the kernel does not support but otherwise
> >responsive.
> 
> Its the same as with every other device - as long as it communicates like a tpm, talks like a tpm, behaves like a tpm - it's a tpm. 
> Even if the kernel does not recognize the tpm's internal state.
> 
> 
> >If you really think that accessing a device that is in unsupported
> >state at boot (as opposed to getting unto unsupported state during
> >device operation after boot) is a real problem it can be selectable as
> >compile time option so people who do not want the code do not get it.
> 
> I would more favor a module option, 
> but honestly I don't see a reason to not pull this code in, as it is.
> Maybe mark the kernel as tainted if you think it is an issue.
> 
> Adding this as a out of tree patch is far from userfriendly.
> If there is a chance to debug and fix a "unknown" state using the kernel as the communication layer, I would like to use this way.
> 
> 
> Peter

As I said in previous response it's not a good idea to give all-in
access at this point. You cannot turn back from that once it is in
the mainline.

I would rather suggest scoping lowest common denominator subset of
TPM commands that you need and allow only those commands to pass
through. If the subset turns out to be too limited, you can expand
it later on.

/Jarkko
