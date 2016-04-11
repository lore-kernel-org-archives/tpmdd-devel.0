From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 08/10] devicetree: Add Trusted Computing Group to vendor-prefix.txt
Date: Mon, 11 Apr 2016 17:37:28 -0500
Message-ID: <CAL_JsqLCC7ZMiOQzp7-OAzfd1bL8dukcDg8rON1xiELV_wooPg@mail.gmail.com>
References: <1460323386-16892-1-git-send-email-christophe-h.ricard@st.com>
 <1460323386-16892-9-git-send-email-christophe-h.ricard@st.com>
 <20160411200600.GA23902@rob-hp-laptop> <20160411202119.GA3357@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160411202119.GA3357-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christophe RICARD <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>, jean-luc.blanc-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Apr 11, 2016 at 3:21 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Apr 11, 2016 at 03:06:00PM -0500, Rob Herring wrote:
>> On Sun, Apr 10, 2016 at 11:23:04PM +0200, Christophe Ricard wrote:
>> > Add missing vendor to vendor-prefix.txt.
>> >
>> > Trusted Computing Group design common specifications for
>> > TPM (Trusted Platform Module) vendors.
>> > TCG designates a TPM answering to a public specification.
>>
>> Not sure this should be a vendor prefix. Does TCG actually make h/w?
>
> They define the common multi-vendor register API, similar to AHCI.
>
> I would imagine compatible tags like
>
>  compatible = 'winbond,xxxx','tcg,tis_iomap';
>
> Since there actually is a legal entity administering the spec (unlike
> AHCI?) 'tgc,' seems like a better prefix to me than 'generic-' ?

Well, Intel "manages" the AHCI and EHCI specs. All the generic strings
are somewhat useless in the end IMO.

As long as you aren't planning to use it alone, it is fine.

Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Rob
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
