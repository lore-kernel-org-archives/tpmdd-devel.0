From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] tpm: consolidate the TPM startup code
Date: Wed, 21 Jun 2017 07:04:53 -0400
Message-ID: <1ff1a552-15a9-d8a6-3bcd-3c0f9ff6d71e@linux.vnet.ibm.com>
References: <20170621073134.7436-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170621073134.7436-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On 06/21/2017 03:31 AM, Jarkko Sakkinen wrote:
> Consolidated all the "manual" TPM startup code to a single function
> in order to make code flows a bit cleaner and migrate to tpm_buf.
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Tested-by: Stefan Berger <stefanb@linux.vnet.ibm.com>


FYI:
swtpm chardev --vtpm-proxy  --tpmstate dir=/tmp --log level=1 --tpm2
swtpm chardev --vtpm-proxy  --tpmstate dir=/tmp --log level=1
