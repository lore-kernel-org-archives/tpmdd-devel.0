From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [tpmdd-devel] Intel NUC and fTPM issue on 4.9.2
Date: Tue, 18 Apr 2017 14:49:30 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B543E217F@hasmsx108.ger.corp.intel.com>
References: <20170216180116.GA7145@obsidianresearch.com>
        <CAH=yMtJkmxxm6sn=1DmakXW+P=E7rsBd3iwqsSwaVBvxazE29w@mail.gmail.com>
        <20170216181905.GA7257@obsidianresearch.com>
        <CAH=yMt+tWWDMban86H53Or+KngYLUw5hN0aB=+DaJ+MQOK4=4g@mail.gmail.com>
        <CAH=yMtJ7qWq=YpRaUPh2zzOECjFGiwV3jfBc+4HuvW3wOYt_Vg@mail.gmail.com>
        <CAH=yMtLLrsyqLr9tOm+D2qvcCDNRO3P36hp8hCdJFVtDyJPWGQ@mail.gmail.com>
        <5B8DA87D05A7694D9FA63FD143655C1B54395CD5@hasmsx108.ger.corp.intel.com>
        <20170217164332.GB30677@obsidianresearch.com>
        <1487356105.6424.1.camel@intel.com>
        <20170217190125.GA5984@obsidianresearch.com>
 <20170220104747.dsp3ugixnqfmj6fi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170220104747.dsp3ugixnqfmj6fi@intel.com>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: "davide.guerri@gmail.com" <davide.guerri@gmail.com>
Cc: "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-Id: tpmdd-devel@lists.sourceforge.net



> -----Original Message-----
> From: Jarkko Sakkinen [mailto:jarkko.sakkinen@linux.intel.com]
> Sent: Monday, February 20, 2017 12:48
> To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Sakkinen, Jarkko <jarkko.sakkinen@intel.com>; tpmdd-
> devel@lists.sourceforge.net; davide.guerri@gmail.com
> Subject: Re: [tpmdd-devel] Intel NUC and fTPM issue on 4.9.2
> 
> On Fri, Feb 17, 2017 at 12:01:25PM -0700, Jason Gunthorpe wrote:
> > > I would rather review a patch with proper commit message than just
> > > pick from an email thread in all cases with a proper explanation
> > > what the patch does and why it is the right way to fix the issue.
> >
> > Of course, but I am waiting for Davide to say the approach even works
> > ..
> >
> > Jason
> 
> I'm not sure what would be a good function name but maybe something that
> would state that this is not status quo but workaround for a bug. Since I do not
> have any better suggestion keep the current name if nothing comes up.
> 
> Probably a dev_err message would make sense here to state in klog that
> something is wrong in the BIOS.
> 
> Since there are multiple people complaining about the issue I will take this
> workaround even if the BIOS is fixed.
> 
> /Jarkko


There is finally a BIOS fix 
https://downloadcenter.intel.com/download/26698/NUCs-BIOS-Update-KYSKLi70-86A- 
0045 and newer

Thanks
Tomas

