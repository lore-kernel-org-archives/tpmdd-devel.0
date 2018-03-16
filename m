From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: Regression from efi: call get_event_log before ExitBootServices
Date: Fri, 16 Mar 2018 15:01:56 +0200
Message-ID: <20180316130156.GC5035@linux.intel.com>
References: <ade378f6-c997-1d48-a30d-cceee6435fc8@redhat.com>
 <a3b5f822-f8f4-e2f5-46da-e23e13174f28@redhat.com>
 <cec36124-0950-6ad9-58a8-9bd69e63aa04@redhat.com>
 <0100016206a68850-bd5c96b3-f275-46ea-98b1-1317e02a5d6e-000000@email.amazonses.com>
 <29c1640a-cf19-ca19-7de9-96f202edfb5a@redhat.com>
 <CA+zpnLebtbjbA-Jg+RvMOqwDE5R--9V3hTwMk95Br4vM1LgBjQ@mail.gmail.com>
 <010001620bafa06b-41525407-603e-40a9-ba11-6033b2f5dcc7-000000@email.amazonses.com>
 <CA+zpnLdmg30Beg+uUJNgBQ5gbjXuJ0uVhyzCgf6m7xbx2yARBg@mail.gmail.com>
 <f9098c326ab3070c3215901e3383a3a2d208b2ae.camel@linux.intel.com>
 <f57f77fb-9637-e9f9-2f9c-3244ef652948@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f57f77fb-9637-e9f9-2f9c-3244ef652948@molgen.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Thiebaud Weksteen <tweek@google.com>, Jeremy Cline <jeremy@jcline.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, hdegoede@redhat.com, Javier Martinez Canillas <javierm@redhat.com>, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Mar 12, 2018 at 11:41:25AM +0100, Paul Menzel wrote:
> Dear Jarkko,
> 
> 
> On 03/12/18 11:17, Jarkko Sakkinen wrote:
> > On Sat, 2018-03-10 at 10:45 +0000, Thiebaud Weksteen wrote:
> > > On Fri, Mar 9, 2018 at 5:54 PM Jeremy Cline <jeremy@jcline.org> wrote:
> > > > and it's hanging at "memset(log_tbl, 0, sizeof(*log_tbl) + log_size);"
> > > 
> > > Thanks. Well, it looks like the memory that is supposedly allocated is not
> > > usable. I'm thinking this is a firmware bug.
> > > Ard, would you agree on this assumption? Thoughts on how to proceed?
> > 
> > Check if the BIOS is up to date?
> 
> How would that help? The no regression policy demands, that Linux continues
> working on systems, where it worked before. So upgrading the firmware is no
> solution, is it? Until a solution is found, the commits should be reverted.

Nope. You are right.

/Jarkko
