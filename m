From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Intel NUC and fTPM issue on 4.9.2
Date: Fri, 17 Feb 2017 09:43:32 -0700
Message-ID: <20170217164332.GB30677@obsidianresearch.com>
References: <CAH=yMtLydrTfn3_RkzZFpRL-sASUsHPdxX9m-HJUTyjv=D3ksg@mail.gmail.com>
	<20170216180116.GA7145@obsidianresearch.com>
	<CAH=yMtJkmxxm6sn=1DmakXW+P=E7rsBd3iwqsSwaVBvxazE29w@mail.gmail.com>
	<20170216181905.GA7257@obsidianresearch.com>
	<CAH=yMt+tWWDMban86H53Or+KngYLUw5hN0aB=+DaJ+MQOK4=4g@mail.gmail.com>
	<CAH=yMtJ7qWq=YpRaUPh2zzOECjFGiwV3jfBc+4HuvW3wOYt_Vg@mail.gmail.com>
	<CAH=yMtLLrsyqLr9tOm+D2qvcCDNRO3P36hp8hCdJFVtDyJPWGQ@mail.gmail.com>
	<5B8DA87D05A7694D9FA63FD143655C1B54395CD5@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B54395CD5-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Sakkinen, Jarkko" <jarkko.sakkinen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Davide Guerri <davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 16, 2017 at 10:36:40PM +0000, Winkler, Tomas wrote:
>    This is a BIOS issue + kernel ACPI platform driver refusing to handle
>    overlapping memory space. The issue here is that the ACPI platform
>    driver is not created, however this should not prevent  the tpm_crb
>    driver from working as it registers directly the ACPI device. For now
>    you can suppress the message by adding the device in forbidden_id_list
>    in drivers/acpi/acpi_platform.c
> 
>
>    I'm already testing a fixed BIOS, not sure whether and when it will be
>    available for your particular device.

Do you think we should go ahead with the patch I sent? Or should we
tell users they need a BIOS update?

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
