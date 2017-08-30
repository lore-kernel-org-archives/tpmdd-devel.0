From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RESEND 3/3] tpm-chip: Export TPM device to
 user space even when startup failed
Date: Wed, 30 Aug 2017 14:07:48 +0300
Message-ID: <20170830110721.edidi46sx2qgovzu@linux.intel.com>
References: <20170824083714.10016-1-Alexander.Steffen@infineon.com>
 <20170824083714.10016-4-Alexander.Steffen@infineon.com>
 <20170825172021.lw3ycxqw63ubrcm2@linux.intel.com>
 <adaaeae32ba64d979abfc4b758c63fc0@MUCSE603.infineon.com>
 <20170829125509.55aylht3ikes3bpy@linux.intel.com>
 <20170829151739.315ae581@kitsune.suse.cz>
 <20170830101510.rlkh2p3zecfsrhgl@linux.intel.com>
 <20170830102002.nufnr77whz5jzwfr@linux.intel.com>
 <20170830123416.29117269@kitsune.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170830123416.29117269@kitsune.suse.cz>
Sender: owner-linux-security-module@vger.kernel.org
To: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
Cc: Alexander.Steffen@infineon.com, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Aug 30, 2017 at 12:34:16PM +0200, Michal Suchánek wrote:
> On Wed, 30 Aug 2017 13:20:02 +0300
> Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> 
> > On Wed, Aug 30, 2017 at 01:15:10PM +0300, Jarkko Sakkinen wrote:
> > > On Tue, Aug 29, 2017 at 03:17:39PM +0200, Michal Suchánek wrote:  
> > > > Hello,
> > > > 
> > > > On Tue, 29 Aug 2017 15:55:09 +0300
> > > > Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> > > >   
> > > > > On Mon, Aug 28, 2017 at 05:15:58PM +0000,
> > > > > Alexander.Steffen@infineon.com wrote:  
> > > > > > But is that just because nobody bothered to implement the
> > > > > > necessary logic or for some other reason?    
> > > > > 
> > > > > We do not want user space to access broken hardware. It's a
> > > > > huge risk for system stability and potentially could be used
> > > > > for evil purposes.
> > > > > 
> > > > > This is not going to mainline as it is not suitable for general
> > > > > consumption. You must use a patched kernel if you want this.
> > > > > 
> > > > > /Jarkko
> > > > >   
> > > > 
> > > > It has been pointed out that userspace applications that use
> > > > direct IO access exist for the purpose. So using a kernel driver
> > > > is an improvement over that if the interface is otherwise sane.
> > > > 
> > > > What do you expect is the potential for instability or evil use?  
> > > 
> > > By definition the use of broken hardware can have unpredictable
> > > effects. Use a patched kernel if you want to do it.
> > > 
> > > /Jarkko  
> > 
> > I.e. too many unknown unknowns for mainline.
> > 
> > I could consider a solution for the TPM error case on self-test that
> > allows only restricted subset of commands.
> > 
> > The patch description did not go to *any* detail on how it is used so
> > practically it's unreviewable at this point. There's a big burder of
> > proof and now there's only hand waving.
> > 
> Hello,
> 
> there was a bug patched recently in which Linux was not sending the
> shutdown command on system shutdown. Presumably with this bug some TPMs
> consider being under attack and stop performing most functions.
> However, you should be able to read the log if this is implemented
> sanely. For that the TPM needs to be accessible.
> 
> There are probably other cases when the TPM might be useless for system
> use but it might be useful to access it. For example, does Linux handle
> uninitialized TPMs?
> 
> Thanks
> 
> Michal

Agreed. I still think it would make sense to start with a limited subset
of TPM commands, not with all-command-allowed.

I guess Alexander should be able to propose such subset.

/Jarkko
