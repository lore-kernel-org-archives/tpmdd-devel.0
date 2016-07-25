From: "Peter Huewe" <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH v2 0/2] tpm: add driver for cr50 on SPI
Date: Mon, 25 Jul 2016 19:09:21 +0200
Message-ID: <trinity-26286f32-3045-4711-8972-ee0964b74003-1469466561717@3capp-gmx-bs15>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>,
	<cover.1468985673.git.apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <cover.1468985673.git.apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Andrey,

thanks for the update.

> This patchset adds support for H1 Secure Microcontroller running
> Cr50 firmware. It implements several functions, including TPM-like
> functionality, and communicates over SPI using the FIFO protocol
> described in the PTP Spec, section 6.
> H1 is a proprietary chip that the Chrome OS team is investigating
> for inclusion in future Chromebooks.

so is this "broken" device already in the field? (i.e. can I buy it? how many of them)
from the description it seems not. ("future chromebooks")
--> how likely is it that the firmware of that device will be fixed that it can work with the regular driver?

Although I really like to see driver upstreamed, I also want to avoid maintenance hell for obscure hardware :/

Thanks,
Peter

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
