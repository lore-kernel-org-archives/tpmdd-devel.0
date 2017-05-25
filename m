From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not run tpm2_shutdown
Date: Thu, 25 May 2017 16:54:01 -0400
Message-ID: <cf746443-5ef5-211f-6b62-a5d4d66e27fd@linux.vnet.ibm.com>
References: <1495717956-14252-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20170525155059.GA5151@obsidianresearch.com>
	<f6c024ae-fe93-251a-a176-1f27f25b1e21@linux.vnet.ibm.com>
	<20170525200931.GA12733@obsidianresearch.com>
	<9ff88c24-ca7a-1867-7284-17689fdac655@linux.vnet.ibm.com>
	<20170525204414.GA13742@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170525204414.GA13742-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 05/25/2017 04:44 PM, Jason Gunthorpe wrote:
> On Thu, May 25, 2017 at 04:32:50PM -0400, Stefan Berger wrote:
>
>> It doesn't hang. Everything is torn down immediately. What is primarily
>> annoying are these two log messages:
>> tpm tpm0: tpm_transmit: tpm_send: error -32
>> tpm tpm0: transmit returned -32 while stopping the TPM
> I think it would be better to change the core to suppress that logging
> if the FD is closed.

This particular command will never reach anyone listening on the proxy's 
file descriptor since the tear-down only begins when the front- and 
backend are closed.
The logging happens somewhere else than where the error occurs. What is 
the best way to suppress the logging? Remove it entirely  -- probably 
not. Return a special error code that doesn't get logged? Return a 2nd 
parameter that indicates this condition? It's not clear to me. Why not 
just prevent the command from being sent if it will never reach its 
intended destination ?

   Stefan

>
> Jason
>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
