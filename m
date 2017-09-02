From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RESEND 3/3] tpm-chip: Export TPM device to
 user space even when startup failed
Date: Sat, 2 Sep 2017 13:24:09 +0300
Message-ID: <20170902102409.d4mfdbwybaxzf7tx@linux.intel.com>
References: <20170824083714.10016-1-Alexander.Steffen@infineon.com>
 <20170824083714.10016-4-Alexander.Steffen@infineon.com>
 <20170825172021.lw3ycxqw63ubrcm2@linux.intel.com>
 <adaaeae32ba64d979abfc4b758c63fc0@MUCSE603.infineon.com>
 <20170829125509.55aylht3ikes3bpy@linux.intel.com>
 <20170829151739.315ae581@kitsune.suse.cz>
 <20170830101510.rlkh2p3zecfsrhgl@linux.intel.com>
 <4722067A-082C-40E7-90ED-29EFB3228765@gmx.de>
 <20170830111019.bsd2jod7z2v2jeoi@linux.intel.com>
 <7d87c22c15f64f2da4d73b18ee931e57@MUCSE603.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7d87c22c15f64f2da4d73b18ee931e57@MUCSE603.infineon.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Alexander.Steffen@infineon.com
Cc: peterhuewe@gmx.de, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 31, 2017 at 04:26:10PM +0000, Alexander.Steffen@infineon.com wrote:
> > On Wed, Aug 30, 2017 at 12:41:51PM +0200, Peter Huewe wrote:
> > >
> > >
> > > Am 30. August 2017 12:15:10 MESZ schrieb Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com>:
> > > >On Tue, Aug 29, 2017 at 03:17:39PM +0200, Michal Suchánek wrote:
> > > >> Hello,
> > > >>
> > > >> On Tue, 29 Aug 2017 15:55:09 +0300
> > > >> Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> > > >>
> > > >> > On Mon, Aug 28, 2017 at 05:15:58PM +0000,
> > > >> > Alexander.Steffen@infineon.com wrote:
> > > >> > > But is that just because nobody bothered to implement the
> > > >necessary
> > > >> > > logic or for some other reason?
> > > >> >
> > > >> > We do not want user space to access broken hardware. It's a huge
> > > >risk
> > > >> > for system stability and potentially could be used for evil
> > > >purposes.
> > > >> >
> > > >> > This is not going to mainline as it is not suitable for general
> > > >> > consumption. You must use a patched kernel if you want this.
> > > >> >
> > > >> > /Jarkko
> > > >> >
> > > >>
> > > >> It has been pointed out that userspace applications that use direct
> > > >IO
> > > >> access exist for the purpose. So using a kernel driver is an
> > > >> improvement over that if the interface is otherwise sane.
> > > >>
> > > >> What do you expect is the potential for instability or evil use?
> > > >
> > > >By definition the use of broken hardware can have unpredictable
> > > >effects.
> > > >Use a patched kernel if you want to do it.
> > >
> > > If the s.m.a.r.t selftest of your hard disk fails, you can still
> > > access it, even though the hw selftest says it is broken.
> > > Same situation.
> > 
> > Not sure if you can compare these directly although I get your point.
> > 
> > Waiting for more comments on this. At the moment I'm still dilated to
> > restricted access because it gives more variables for the future.
> > 
> > /Jarkko
> 
> I think, this is a perfect example. In both cases we have intelligent devices, that can detect that they are broken and report it correctly (instead of just malfunction randomly). This also shows that those devices are not so broken that they completely misbehave (i.e. significantly violate their spec), they just do not provide the full functionality anymore.
> 
> Could you give me one example how you'd imagine such a device to impact stability? My patch already prevents the kernel from using broken TPMs for anything, it only provides the communication facilities for user space applications.
> 
> With regard to security/attacks, it is precisely the TPM's job to protect itself (and your secrets). You get all your security guarantees from the TPM, not the driver code, so it does not matter what the driver does, even with a broken TPM.
> 
> I understand your point of not wanting to enable functionality that you cannot disable anymore, but I fail to see why you'd ever want to disable (part of) this functionality again. Knowing more about the potential problems would allow me to prevent them from the beginning or to come up with a better safeguard than the command-based whitelisting.
> 
> Alexander

I think we should hold with this patch set up until we get a mailing
list for tpmdd, which we don't have right now. I've submitted a request
to postmaster@vger.kernel.org but haven't received any feedback. I'll
inform in the linux-security-module list when the new list is created
so you know.

Some of the comments make sense like the one Peter mentioned earlier
and your comments about TPM security but you failed to address these
in the cover letter. For next iteration put this to the cover letter.

Thanks.

/Jarkko
