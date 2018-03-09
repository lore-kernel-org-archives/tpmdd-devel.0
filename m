From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Regression from efi: call get_event_log before ExitBootServices
Date: Fri, 09 Mar 2018 09:03:13 -0800
Message-ID: <1520614993.12216.3.camel@HansenPartnership.com>
References: <01000161fc0b4755-df0621f4-ab5d-479a-b425-adf98427a308-000000@email.amazonses.com>
         <e7c2be5c-cf21-fc2d-efda-d9222d93ffad@redhat.com>
         <b32f335c-0d77-1749-f7fe-65f512280255@redhat.com>
         <ade378f6-c997-1d48-a30d-cceee6435fc8@redhat.com>
         <a3b5f822-f8f4-e2f5-46da-e23e13174f28@redhat.com>
         <cec36124-0950-6ad9-58a8-9bd69e63aa04@redhat.com>
         <0100016206a68850-bd5c96b3-f275-46ea-98b1-1317e02a5d6e-000000@email.amazonses.com>
         <29c1640a-cf19-ca19-7de9-96f202edfb5a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <29c1640a-cf19-ca19-7de9-96f202edfb5a@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Jeremy Cline <jeremy@jcline.org>, Javier Martinez Canillas <javierm@redhat.com>, Thiebaud Weksteen <tweek@google.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2018-03-09 at 10:29 +0100, Hans de Goede wrote:
> Hi,
> 
> On 08-03-18 18:26, Jeremy Cline wrote:
> > 
> > On 03/08/2018 11:50 AM, Hans de Goede wrote:
[...]
> > > > The UEFI firmware does some measurements and so does shim. So
> > > > you should have some event logs. What version of shim are you
> > > > using? And also would be good to know if it's the same shim
> > > > version that Jeremy is using.
> > > 
> > > That is a very good question, I'm using: shim-ia32-13-0.7.x86_64, 
> > > which is the last version for F27 AFAICT.
> > 
> > All my tablet has installed is shim-0.8-10.x86_64, no shim-ia32.
> 
> Yes my bad, although if the kernel changes break booting on systems
> without the shim that is still good to know and something which
> we probably ought to fix.

My laptop is set up with secure boot but without shim using a shim
protocol thin layer to check the kernel signature against db variables:

https://git.kernel.org/pub/scm/linux/kernel/git/jejb/efitools.git/tree/ShimReplace.c

and I haven't seen any breakage, so not having a shim that does
measurements works for me all the way up to -rc4.

James
