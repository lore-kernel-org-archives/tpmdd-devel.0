From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not access host's event log
Date: Mon, 21 Nov 2016 11:32:34 -0700
Message-ID: <20161121183234.GB9234@obsidianresearch.com>
References: <1479306245-14456-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20161116153731.pmmnxiai7ouuj6qf@intel.com>
 <3a38ddc6-1758-ae82-3df3-9cc55906880d@linux.vnet.ibm.com>
 <65f392b6-5141-c726-dacb-a1649ea215de@linux.vnet.ibm.com>
 <20161116200759.GA19593@obsidianresearch.com>
 <ef1f954d-fc52-0522-01f7-b0e31ea14c59@linux.vnet.ibm.com>
 <20161117203743.odzdpwwynzlqyt5m@intel.com>
 <abef96f0-97e3-22e6-c63b-4be5622b4fc2@linux.vnet.ibm.com>
 <77bf7806-5007-feb4-e4a0-fc94775a5271@linux.vnet.ibm.com>
 <8e1bea0b-5409-5b69-7ac1-1e3e29cc3da7@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8e1bea0b-5409-5b69-7ac1-1e3e29cc3da7@linux.vnet.ibm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net, nayna@linux.vnet.ibm.com, linux-acpi@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Nov 18, 2016 at 11:58:08AM -0500, Stefan Berger wrote:

> reason is just the acpi_os_map_iomem() call. Without calling the
> acpi_os_unmap_iomem() later on, which I assume should be allowed, the driver
> will crash when the device terminates.

The oops looks like unbalacned map/unmap, can you add some tracing
around the failing address and see if that is possibly true, and who
does it?

Jason
